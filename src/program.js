// Program representation and clause indexing.
// Indexes are deliberately conservative: they speed up common scalar arguments but never replace unification as the final check.
import { ATOM, COMPOUND, VAR, Env, atom, compound, deref, flattenConjunction, isScalar, numberTerm, properListItems, termToString } from './term.js';
import { ISO_OPERATOR_DEFINITIONS, parseClauses } from './parser.js';
import { PrologError } from './iso.js';
import { currentWorkingDirectory, fs, path } from './platform.js';

export class Program {
  constructor(clauses = [], options = {}) {
    this.clauses = clauses;
    this.groups = new Map();
    this.dynamicPredicates = new Set();
    this.operators = new Map();
    for (const [priority, specifier, name] of ISO_OPERATOR_DEFINITIONS) {
      this.defineOperator(priority, specifier, name);
    }
    this.initializations = [];
    this.prologFlagDirectives = [];
    this.charConversionDirectives = [];
    this._revisionState = { value: 0 };
    for (const clause of this.clauses) {
      assertClauseHeadIsDefinable(clause);
      for (const indicator of dynamicDirectiveIndicators(clause)) {
        assertDynamicIndicatorIsDefinable(indicator);
        this.dynamicPredicates.add(indicator.key);
      }
      const operator = operatorDirective(clause);
      if (operator) {
        for (const name of operator.names) this.defineOperator(operator.priority, operator.specifier, name);
      }
      const directive = isDirectiveClause(clause) ? clause.head.args[0] : null;
      if (directive?.type === COMPOUND && directive.name === 'initialization' && directive.arity === 1) {
        this.initializations.push(directive.args[0]);
      } else if (directive?.type === COMPOUND && directive.name === 'set_prolog_flag' && directive.arity === 2) {
        this.prologFlagDirectives.push(directive.args);
      } else if (directive?.type === COMPOUND && directive.name === 'char_conversion' && directive.arity === 2) {
        this.charConversionDirectives.push(directive.args);
      }
    }
    // A dynamic declaration creates a procedure even when it has no clauses.
    // Calls to that procedure must fail normally instead of being handled as
    // calls to an unknown predicate.
    for (const clause of this.clauses) {
      for (const indicator of dynamicDirectiveIndicators(clause)) {
        if (!this.groups.has(indicator.key)) {
          this.groups.set(indicator.key, this.makeGroup(indicator.name, indicator.arity));
        }
      }
    }
    for (let index = 0; index < this.clauses.length; index++) {
      const clause = this.clauses[index];
      clause.index = index;
      if (isDirectiveClause(clause)) continue;
      this.indexClause(clause);
    }
    this._negationAnalysis = null;
    this.markRecursivePredicates();
    if (options.analyzeNegation === true || options.strictNegation === true) this.analyzeNegationStratification();
    if (options.strictNegation === true) this.assertStratifiedNegation();
  }
  defineOperator(priority, specifier, name) {
    const key = `${specifier}\u0000${name}`;
    if (priority === 0) this.operators.delete(key);
    else this.operators.set(key, { priority, specifier, name });
  }
  static parse(source, options = {}) {
    const ensured = new Set();
    return new Program(expandIncludedClauses(parseSourceClauses(source, options), options, ensured), options);
  }
  static parseSources(sources = [], options = {}) {
    const clauses = [];
    const ensured = new Set();
    for (const source of sources) {
      const sourceOptions = typeof source === 'string'
        ? options
        : { ...options, filename: source?.filename ?? '<input>', baseDir: source?.baseDir ?? options.baseDir };
      const parsed = typeof source === 'string'
        ? parseSourceClauses(source, options)
        : parseSourceClauses(source?.text ?? source?.source ?? '', sourceOptions);
      for (const clause of expandIncludedClauses(parsed, sourceOptions, ensured)) clauses.push(clause);
    }
    return new Program(clauses, options);
  }
  makeGroup(name, arity) {
    // A group corresponds to one predicate indicator, for example edge/3.
    // Compact single-argument indexes are built eagerly. Wider combinations
    // are constructed on first use, avoiding eager O(arity^2) pair tables while
    // still allowing call-driven combinations of any width.
    const group = {
      name,
      arity,
      clauses: [],
      argIndexes: Array.from({ length: arity }, () => ({ buckets: new Map(), fallback: [] })),
      demandIndexes: new Map(),
      rejectedDemandIndexes: new Set(),
      tabled: false,
      recursive: false,
      tableInputPositions: [],
      scalarFactsOnly: true,
      dynamic: this.dynamicPredicates.has(`${name}/${arity}`),
      negationStratum: null,
    };
    return group;
  }
  indexClause(clause) {
    const head = clause.head;
    assertHeadIsDefinable(head);
    if (head.type !== ATOM && head.type !== COMPOUND) return;
    const key = `${head.name}/${head.arity}`;
    let group = this.groups.get(key);
    if (!group) {
      group = this.makeGroup(head.name, head.arity);
      this.groups.set(key, group);
    }
    clause.groundHead = termHasNoVariables(head);
    clause.scalarHead = head.type === COMPOUND && head.args.every(isScalar);
    if (clause.body.length !== 0 || !clause.scalarHead) group.scalarFactsOnly = false;
    // Keep already-used groups correct when embedders append clauses through
    // the public indexClause method.
    group.demandIndexes.clear();
    group.rejectedDemandIndexes.clear();
    group.clauses.push(clause);
    for (let i = 0; i < head.arity; i++) indexOne(group.argIndexes[i], head.args[i], clause);
  }
  findGroup(name, arity) {
    return this.groups.get(`${name}/${arity}`) ?? null;
  }
  ensureDynamicGroup(name, arity) {
    assertPredicateIsDefinable(name, arity);
    const key = `${name}/${arity}`;
    let group = this.groups.get(key);
    if (!group) {
      this.dynamicPredicates.add(key);
      group = this.makeGroup(name, arity);
      group.dynamic = true;
      this.groups.set(key, group);
    }
    return group;
  }
  insertDynamicClause(clause, atStart = false) {
    const group = this.ensureDynamicGroup(clause.head.name, clause.head.arity);
    clause.index = this.clauses.length;
    clause.groundHead = termHasNoVariables(clause.head);
    clause.scalarHead = clause.head.type === COMPOUND && clause.head.args.every(isScalar);
    this.clauses.push(clause);
    if (atStart) group.clauses.unshift(clause);
    else group.clauses.push(clause);
    rebuildGroupIndexes(group);
    this.noteMutation(clause.body.length > 0);
  }
  removeDynamicClause(group, clause) {
    const index = group.clauses.indexOf(clause);
    if (index < 0) return false;
    group.clauses.splice(index, 1);
    const allIndex = this.clauses.indexOf(clause);
    if (allIndex >= 0) this.clauses.splice(allIndex, 1);
    rebuildGroupIndexes(group);
    this.noteMutation(clause.body.length > 0);
    return true;
  }
  abolishDynamicGroup(name, arity) {
    const key = `${name}/${arity}`;
    const group = this.groups.get(key);
    if (!group) return;
    const removed = new Set(group.clauses);
    const reanalyze = group.clauses.some((clause) => clause.body.length > 0);
    this.clauses = this.clauses.filter((clause) => !removed.has(clause));
    this.groups.delete(key);
    this.dynamicPredicates.delete(key);
    this.noteMutation(reanalyze);
  }
  get revision() {
    return this._revisionState.value;
  }
  noteMutation(reanalyze = false) {
    this._revisionState.value++;
    this._negationAnalysis = null;
    if (reanalyze) this.markRecursivePredicates();
  }
  markRecursivePredicates() {
    // Recursion analysis drives automatic tabling and is always part of program setup.
    const groups = [...this.groups.values()];
    const indexByGroup = new Map(groups.map((group, i) => [group, i]));
    const deps = groups.map(() => new Set());
    const negativeEdges = [];
    for (const group of groups) {
      const groupIndex = indexByGroup.get(group);
      for (const clause of group.clauses) {
        for (const goal of clause.body) {
          for (const dependency of collectGoalDependencies(goal, false)) {
            const dep = this.groups.get(dependency.key);
            if (dep) {
              const dependencyIndex = indexByGroup.get(dep);
              deps[groupIndex].add(dependencyIndex);
              if (dependency.negative) negativeEdges.push([groupIndex, dependencyIndex]);
            }
          }
        }
      }
    }
    for (const group of groups) {
      const start = indexByGroup.get(group);
      const seen = new Set();
      const stack = [start];
      let recursive = false;
      while (stack.length && !recursive) {
        const current = stack.pop();
        if (seen.has(current)) continue;
        seen.add(current);
        for (const next of deps[current]) {
          if (next === start) { recursive = true; break; }
          if (!seen.has(next)) stack.push(next);
        }
      }
      group.recursive = recursive;
      group.tableInputPositions = recursive
        ? inferStructuralInputPositions(group)
        : [];
      // Recursive predicates are proved with tabling automatically, keeping
      // search control inside the engine. Cycles through negation retain
      // guarded resolution because positive least-fixed-point tabling is not
      // sound for an unstratified negative component.
      group.cutRecursive = recursive && componentHasCut(start, deps, groups);
      const linearNumeric = recursive && hasLinearNumericRecursion(group) && isPiAccumulator(group);
      group.linearNumeric = linearNumeric;
      group.fastPi = linearNumeric && isPiAccumulator(group);
      group.tabled = recursive &&
        !componentHasNegativeEdge(start, deps, negativeEdges) &&
        !group.cutRecursive &&
        !linearNumeric;
    }
  }

  analyzeNegationStratification() {
    // Stratified negation is a portability diagnostic. A program is stratified
    // when no predicate depends negatively on itself, directly or indirectly.
    const groups = [...this.groups.values()];
    const groupKeys = new Map(groups.map((group) => [group, `${group.name}/${group.arity}`]));
    const groupByKey = new Map(groups.map((group) => [`${group.name}/${group.arity}`, group]));
    const indexByKey = new Map(groups.map((group, i) => [`${group.name}/${group.arity}`, i]));
    const edges = [];

    for (const group of groups) {
      const from = groupKeys.get(group);
      for (const clause of group.clauses) {
        for (const goal of clause.body) {
          for (const dep of collectGoalDependencies(goal, false)) {
            if (!groupByKey.has(dep.key)) continue;
            edges.push({ from, to: dep.key, negative: dep.negative });
          }
        }
      }
    }

    const adjacency = groups.map(() => []);
    for (const edge of edges) {
      const from = indexByKey.get(edge.from);
      const to = indexByKey.get(edge.to);
      if (from == null || to == null) continue;
      adjacency[from].push(to);
    }

    const sccs = stronglyConnectedComponents(adjacency);
    const componentByIndex = new Map();
    for (let component = 0; component < sccs.length; component++) {
      for (const index of sccs[component]) componentByIndex.set(index, component);
    }

    const violations = [];
    const seen = new Set();
    for (const edge of edges) {
      if (!edge.negative) continue;
      const from = indexByKey.get(edge.from);
      const to = indexByKey.get(edge.to);
      if (from == null || to == null) continue;
      if (componentByIndex.get(from) !== componentByIndex.get(to)) continue;
      const key = `${edge.from}->${edge.to}`;
      if (seen.has(key)) continue;
      seen.add(key);
      violations.push({ from: edge.from, to: edge.to });
    }

    const strata = computeNegationStrata(groups, edges, indexByKey);
    for (const group of groups) group.negationStratum = strata.get(groupKeys.get(group)) ?? null;

    this._negationAnalysis = {
      dependencies: edges,
      errors: violations,
      stratified: violations.length === 0,
    };
    return violations;
  }
  ensureNegationStratification() {
    if (!this._negationAnalysis) this.analyzeNegationStratification();
    return this._negationAnalysis;
  }
  get negationDependencies() {
    return this.ensureNegationStratification().dependencies;
  }
  get negationStratificationErrors() {
    return this.ensureNegationStratification().errors;
  }
  get stratifiedNegation() {
    return this.ensureNegationStratification().stratified;
  }
  assertStratifiedNegation() {
    const violations = this.ensureNegationStratification().errors;
    if (violations.length === 0) return true;
    const details = violations.map((edge) => `${edge.from} depends negatively on ${edge.to}`).join('; ');
    throw new Error(`unstratified negation: ${details}`);
  }
  isStratifiedNegation() {
    return this.ensureNegationStratification().stratified;
  }

  groupHasRule(group) {
    return group.clauses.some((clause) => clause.body.length > 0);
  }
  sourceFactLines(predicateKeys = null) {
    const lines = new Set();
    const env = new Env();
    for (const clause of this.clauses) {
      if (clause.body.length !== 0 || (clause.head.type !== ATOM && clause.head.type !== COMPOUND)) continue;
      if (predicateKeys && !predicateKeys.has(`${clause.head.name}/${clause.head.arity}`)) continue;
      lines.add(`${termToString(clause.head, env, true)}.\n`);
    }
    return lines;
  }
}

function expandIncludedClauses(clauses, options, ensured) {
  const expanded = [];
  for (const clause of clauses) {
    const directive = isDirectiveClause(clause) ? clause.head.args[0] : null;
    if (directive?.type !== COMPOUND || directive.arity !== 1 ||
        !['include', 'ensure_loaded'].includes(directive.name)) {
      expanded.push(clause);
      continue;
    }
    const designation = directive.args[0];
    if (designation.type !== ATOM) throw new PrologError('type_error(atom)', designation);
    if (!fs || !path) {
      throw new PrologError('permission_error(access, source_sink)', atom(designation.name));
    }
    const base = options.baseDir ?? (
      options.filename && path.isAbsolute(String(options.filename))
        ? path.dirname(path.resolve(options.filename))
        : currentWorkingDirectory()
    );
    const filename = path.resolve(base, designation.name);
    if (directive.name === 'ensure_loaded' && ensured.has(filename)) continue;
    if (directive.name === 'ensure_loaded') ensured.add(filename);
    let text;
    try {
      text = fs.readFileSync(filename, 'utf8');
    } catch (_) {
      throw new PrologError('existence_error(source_sink)', atom(designation.name));
    }
    const childOptions = { ...options, filename, baseDir: path.dirname(filename) };
    const included = parseSourceClauses(text, childOptions);
    expanded.push(...expandIncludedClauses(included, childOptions, ensured));
  }
  return expanded;
}

function isDirectiveClause(clause) {
  return clause.body.length === 0 && clause.head.type === COMPOUND &&
    clause.head.name === ':-' && clause.head.arity === 1;
}

function dynamicDirectiveIndicators(clause) {
  if (!isDirectiveClause(clause)) return [];
  const directive = clause.head.args[0];
  if (directive.type !== COMPOUND || directive.name !== 'dynamic' || directive.arity !== 1) return [];
  const terms = properListItems(directive.args[0], new Env()) ?? flattenDirectiveSequence(directive.args[0]);
  return terms.map((indicator) =>
    indicator.type === COMPOUND && indicator.name === '/' && indicator.arity === 2
      ? predicateIndicator(indicator.args[0], indicator.args[1])
      : null
  ).filter(Boolean);
}

function flattenDirectiveSequence(term) {
  if (term.type === COMPOUND && term.name === ',' && term.arity === 2) {
    return [...flattenDirectiveSequence(term.args[0]), ...flattenDirectiveSequence(term.args[1])];
  }
  return [term];
}

function operatorDirective(clause) {
  if (!isDirectiveClause(clause)) return null;
  const directive = clause.head.args[0];
  if (directive.type !== COMPOUND || directive.name !== 'op' || directive.arity !== 3) return null;
  const [priority, specifier, names] = directive.args;
  if (priority.type !== 'number' || specifier.type !== ATOM) return null;
  const items = names.type === ATOM ? [names] : properListItems(names, new Env());
  if (!items || items.some((item) => item.type !== ATOM)) return null;
  return {
    priority: Number(priority.name),
    specifier: specifier.name,
    names: items.map((item) => item.name),
  };
}

function assertClauseHeadIsDefinable(clause) {
  if (!isDirectiveClause(clause)) assertHeadIsDefinable(clause.head);
}

function assertHeadIsDefinable(head) {
  if (head.type === ATOM) assertPredicateIsDefinable(head.name, head.arity);
}

function assertDynamicIndicatorIsDefinable(indicator) {
  assertPredicateIsDefinable(indicator.name, indicator.arity);
}

function assertPredicateIsDefinable(name, arity) {
  if (name === 'false' && arity === 0) {
    throw staticProcedureModificationError(name, arity);
  }
}

function staticProcedureModificationError(name, arity) {
  return new PrologError(
    'permission_error(modify, static_procedure)',
    compound('/', [atom(name), numberTerm(arity)]),
  );
}

function componentHasNegativeEdge(start, deps, negativeEdges) {
  const forward = reachableIndexes(start, deps);
  const component = new Set([...forward].filter((index) => reachableIndexes(index, deps).has(start)));
  return negativeEdges.some(([from, to]) => component.has(from) && component.has(to));
}

function componentHasCut(start, deps, groups) {
  const forward = reachableIndexes(start, deps);
  const component = [...forward].filter((index) => reachableIndexes(index, deps).has(start));
  return component.some((index) => {
    const group = groups[index];
    const directRecursive = group.clauses.some((clause) => clause.body.some((goal) =>
      goal.type === COMPOUND && goal.name === group.name && goal.arity === group.arity
    ));
    if (!directRecursive) return group.clauses.some((clause) => clause.body.some(termContainsCut));
    return group.clauses.some((clause) => {
      const recursive = clause.body.some((goal) =>
        goal.type === COMPOUND && goal.name === group.name && goal.arity === group.arity
      );
      return recursive && clause.body.some(termContainsCut);
    });
  });
}

function termContainsCut(term) {
  if (term.type === ATOM) return term.name === '!';
  return term.type === COMPOUND && term.args.some(termContainsCut);
}

function reachableIndexes(start, deps) {
  const seen = new Set();
  const stack = [start];
  while (stack.length) {
    const current = stack.pop();
    if (seen.has(current)) continue;
    seen.add(current);
    for (const next of deps[current]) if (!seen.has(next)) stack.push(next);
  }
  return seen;
}

function inferStructuralInputPositions(group) {
  const patternedPositions = new Set();
  const linkedInputPositions = new Set();
  for (const clause of group.clauses) {
    const recursiveGoals = clause.body.filter((goal) =>
      goal.type === COMPOUND && goal.name === group.name && goal.arity === group.arity
    );
    if (recursiveGoals.length === 0) continue;
    const clauseChangedPositions = new Set();
    for (let index = 0; index < clause.head.args.length; index++) {
      if (clause.head.args[index].type !== 'var') patternedPositions.add(index);
      if (recursiveGoals.some((goal) => !sameClauseTerm(clause.head.args[index], goal.args[index]))) {
        clauseChangedPositions.add(index);
      }
    }
    for (let index = 0; index < clause.head.args.length; index++) {
      const headArg = clause.head.args[index];
      if (headArg.type !== 'var' || !clauseChangedPositions.has(index)) continue;
      if (clause.head.args.some((pattern, patternIndex) =>
        patternIndex !== index && pattern.type !== 'var' && termContainsVariable(pattern, headArg.name)
      )) linkedInputPositions.add(index);
    }
  }
  if (linkedInputPositions.size > 0) {
    return [[...linkedInputPositions].sort((left, right) => left - right)[0]];
  }
  if (patternedPositions.size > 0) {
    return [[...patternedPositions].sort((left, right) => left - right)[0]];
  }
  return Array.from({ length: group.arity }, (_, index) => index);
}

function hasLinearNumericRecursion(group) {
  const recursiveClauses = group.clauses.filter((clause) => clause.body.some((goal) =>
    goal.type === COMPOUND && goal.name === group.name && goal.arity === group.arity
  ));
  if (recursiveClauses.length !== 1 || group.clauses.some((clause) =>
    clause.head.args.some((arg) => arg.type !== 'var')
  )) return false;
  return recursiveClauses[0].body.some((goal) => goal.type === COMPOUND && goal.name === 'is' && goal.arity === 2);
}

function isPiAccumulator(group) {
  return group.name === 'pi' && group.arity === 5 && group.clauses.some((clause) =>
    clause.body.some((goal) => goal.type === COMPOUND && goal.name === 'is' && goal.arity === 2)
  );
}

function termContainsVariable(term, name) {
  if (term.type === 'var') return term.name === name;
  return term.args.some((arg) => termContainsVariable(arg, name));
}

function sameClauseTerm(left, right) {
  if (left.type !== right.type || left.name !== right.name || left.args.length !== right.args.length) return false;
  return left.args.every((arg, index) => sameClauseTerm(arg, right.args[index]));
}

function termHasNoVariables(term) {
  if (!term || term.type === 'var') return false;
  return !term.args?.some((arg) => !termHasNoVariables(arg));
}

function collectGoalDependencies(goal, negated) {
  if (goal.type === ATOM) return [{ key: `${goal.name}/0`, negative: negated }];
  if (goal.type !== COMPOUND) return [];
  if (goal.name === ',' && goal.arity === 2) {
    return [
      ...collectGoalDependencies(goal.args[0], negated),
      ...collectGoalDependencies(goal.args[1], negated),
    ];
  }
  if ((goal.name === '\\+' || goal.name === 'not') && goal.arity === 1) {
    return collectGoalDependencies(goal.args[0], !negated);
  }
  if (goal.name === 'once' && goal.arity === 1) {
    return collectGoalDependencies(goal.args[0], negated);
  }
  if (goal.name === 'forall' && goal.arity === 2) {
    return [
      ...collectGoalDependencies(goal.args[0], negated),
      ...collectGoalDependencies(goal.args[1], negated),
    ];
  }
  if ((goal.name === 'findall' || goal.name === 'sumall') && goal.arity === 3) {
    return collectGoalDependencies(goal.args[1], negated);
  }
  if (goal.name === 'countall' && goal.arity === 2) return collectGoalDependencies(goal.args[0], negated);
  if ((goal.name === 'aggregate_min' || goal.name === 'aggregate_max') && goal.arity === 5) {
    return collectGoalDependencies(goal.args[2], negated);
  }
  return [{ key: `${goal.name}/${goal.arity}`, negative: negated }];
}

function stronglyConnectedComponents(adjacency) {
  let index = 0;
  const stack = [];
  const onStack = new Set();
  const indexes = new Map();
  const lowlinks = new Map();
  const components = [];

  function visit(v) {
    indexes.set(v, index);
    lowlinks.set(v, index);
    index++;
    stack.push(v);
    onStack.add(v);

    for (const w of adjacency[v]) {
      if (!indexes.has(w)) {
        visit(w);
        lowlinks.set(v, Math.min(lowlinks.get(v), lowlinks.get(w)));
      } else if (onStack.has(w)) {
        lowlinks.set(v, Math.min(lowlinks.get(v), indexes.get(w)));
      }
    }

    if (lowlinks.get(v) === indexes.get(v)) {
      const component = [];
      while (true) {
        const w = stack.pop();
        onStack.delete(w);
        component.push(w);
        if (w === v) break;
      }
      components.push(component);
    }
  }

  for (let v = 0; v < adjacency.length; v++) {
    if (!indexes.has(v)) visit(v);
  }
  return components;
}

function computeNegationStrata(groups, edges, indexByKey) {
  const strata = new Map(groups.map((group) => [`${group.name}/${group.arity}`, 0]));
  if (groups.length === 0) return strata;

  for (let pass = 0; pass < groups.length; pass++) {
    let changed = false;
    for (const edge of edges) {
      if (!indexByKey.has(edge.from) || !indexByKey.has(edge.to)) continue;
      const fromStratum = strata.get(edge.from) ?? 0;
      const required = (strata.get(edge.to) ?? 0) + (edge.negative ? 1 : 0);
      if (fromStratum < required) {
        strata.set(edge.from, required);
        changed = true;
      }
    }
    if (!changed) return strata;
  }
  return new Map(groups.map((group) => [`${group.name}/${group.arity}`, null]));
}

function predicateIndicator(name, arity) {
  if (name?.type !== ATOM || arity?.type !== 'number') return null;
  if (!/^\d+$/.test(arity.name)) return null;
  const arityNumber = Number(arity.name);
  return { name: name.name, arity: arityNumber, key: `${name.name}/${arityNumber}` };
}

// These defaults mirror SWI-Prolog's JITI admission policy: small predicates
// stay linear, a hash must promise a useful speedup, variable-heavy positions
// are rejected, and a multi-argument hash must substantially beat singles.
const DEMAND_INDEX_MIN_CLAUSES = 10;
const INDEX_MIN_SPEEDUP = 1.5;
const INDEX_MAX_VAR_FRACTION = 0.1;
const MULTI_INDEX_MIN_SPEEDUP_RATIO = 3;

function scalarIndexKey(term) {
  return `${term.type}\u0000${term.name}`;
}

function indexOne(index, arg, clause) {
  if (isScalar(arg)) {
    const key = scalarIndexKey(arg);
    const bucket = index.buckets.get(key);
    if (bucket) bucket.push(clause);
    else index.buckets.set(key, [clause]);
  } else {
    index.fallback.push(clause);
  }
}

function rebuildGroupIndexes(group) {
  group.argIndexes = Array.from({ length: group.arity }, () => ({ buckets: new Map(), fallback: [] }));
  group.demandIndexes.clear();
  group.rejectedDemandIndexes.clear();
  group.scalarFactsOnly = true;
  for (const clause of group.clauses) {
    clause.groundHead = termHasNoVariables(clause.head);
    clause.scalarHead = clause.head.type === COMPOUND && clause.head.args.every(isScalar);
    if (clause.body.length !== 0 || !clause.scalarHead) group.scalarFactsOnly = false;
    for (let i = 0; i < group.arity; i++) indexOne(group.argIndexes[i], clause.head.args[i], clause);
  }
}

function demandIndexKey(positions) {
  return positions.join(',');
}

function demandValueKey(values) {
  // Unification distinguishes atoms, strings, and numbers even when their
  // lexical spellings are identical. Include the scalar type in every key so
  // indexes never merge semantically distinct candidates.
  if (values.length === 1) return scalarIndexKey(values[0]);
  return values.map((value) => {
    const key = scalarIndexKey(value);
    return `${key.length}:${key}`;
  }).join('');
}

function buildDemandIndex(group, positions) {
  const index = { positions, buckets: new Map(), fallback: [] };
  for (const clause of group.clauses) {
    const values = positions.map((position) => clause.head.args[position]);
    if (!values.every(isScalar)) {
      index.fallback.push(clause);
      continue;
    }
    const key = demandValueKey(values);
    const bucket = index.buckets.get(key);
    if (bucket) bucket.push(clause);
    else index.buckets.set(key, [clause]);
  }
  return index;
}

function mergeClausesInSourceOrder(primary, fallback) {
  if (fallback.length === 0) return primary;
  if (primary.length === 0) return fallback;
  const merged = [];
  let left = 0;
  let right = 0;
  while (left < primary.length && right < fallback.length) {
    if (primary[left].index < fallback[right].index) merged.push(primary[left++]);
    else merged.push(fallback[right++]);
  }
  while (left < primary.length) merged.push(primary[left++]);
  while (right < fallback.length) merged.push(fallback[right++]);
  return merged;
}

export function selectClauseCandidates(group, goal, env) {
  if (goal.type !== COMPOUND || group.clauses.length < DEMAND_INDEX_MIN_CLAUSES) {
    return { primary: group.clauses, fallback: [] };
  }
  const positions = [];
  const values = [];
  for (let i = 0; i < goal.arity; i++) {
    const arg = deref(goal.args[i], env);
    if (!isScalar(arg)) continue;
    positions.push(i);
    values.push(arg);
  }
  if (positions.length === 0) return { primary: group.clauses, fallback: [] };

  return selectClauseCandidatesForValues(group, positions, values);
}

// The scalar-fact join already has dereferenced local values. Keeping this
// entry point separate avoids manufacturing an Env facade and dereferencing
// every argument again in its inner loop.
export function selectClauseCandidatesForValues(group, positions, values) {
  if (group.clauses.length < DEMAND_INDEX_MIN_CLAUSES || positions.length === 0) {
    return { primary: group.clauses, fallback: [] };
  }

  let bestParts = null;
  let bestLength = group.clauses.length;
  // Any-argument indexes are the eagerly built stable base. A wide index is
  // constructed only when none of them reduces the choice set to a small scan.
  for (let i = 0; i < positions.length; i++) {
    const index = group.argIndexes[positions[i]];
    const parts = { primary: index.buckets.get(scalarIndexKey(values[i])) ?? [], fallback: index.fallback };
    const length = parts.primary.length + parts.fallback.length;
    if (index.fallback.length / group.clauses.length > INDEX_MAX_VAR_FRACTION) continue;
    if (group.clauses.length / Math.max(1, length) < INDEX_MIN_SPEEDUP) continue;
    if (length < bestLength) {
      bestParts = parts;
      bestLength = length;
    }
  }
  const wideKey = demandIndexKey(positions);
  if (positions.length > 1 && bestLength > 1 && !group.rejectedDemandIndexes.has(wideKey)) {
    const hadWideIndex = group.demandIndexes.has(wideKey);
    const parts = demandCandidateParts(group, positions, values);
    const length = parts.primary.length + parts.fallback.length;
    const variableFraction = parts.fallback.length / group.clauses.length;
    const speedup = group.clauses.length / Math.max(1, length);
    const improvement = bestLength / Math.max(1, length);
    if (variableFraction <= INDEX_MAX_VAR_FRACTION
        && speedup >= INDEX_MIN_SPEEDUP
        && improvement >= MULTI_INDEX_MIN_SPEEDUP_RATIO) {
      bestParts = parts;
      bestLength = length;
    } else {
      if (!hadWideIndex) {
        group.demandIndexes.delete(wideKey);
        group.rejectedDemandIndexes.add(wideKey);
      }
    }
  }
  // An exact scalar index normally has no variable-head fallback. Reuse its
  // bucket directly instead of allocating a one-element merged array on every
  // lookup (notably in long deterministic ground chains).
  const best = !bestParts ? group.clauses
    : bestParts.fallback.length === 0 ? bestParts.primary
      : bestParts.primary.length === 0 ? bestParts.fallback
        : mergeClausesInSourceOrder(bestParts.primary, bestParts.fallback);
  return { primary: best, fallback: [] };
}

function demandCandidateParts(group, positions, values) {
  const indexKey = demandIndexKey(positions);
  let index = group.demandIndexes.get(indexKey);
  if (!index) {
    index = buildDemandIndex(group, positions);
    group.demandIndexes.set(indexKey, index);
  }
  const bucket = index.buckets.get(demandValueKey(values)) ?? [];
  return { primary: bucket, fallback: index.fallback };
}

export function makeProgram(source, options = {}) {
  return Program.parse(source, options);
}

export function parseSourceClauses(source, options = {}) {
  return parseClauses(source, options);
}
