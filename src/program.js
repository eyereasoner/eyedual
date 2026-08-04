// Program representation and clause indexing.
// Indexes are deliberately conservative: they speed up common scalar arguments but never replace unification as the final check.
import { ATOM, COMPOUND, VAR, Env, atom, compound, deref, flattenConjunction, isScalar, numberTerm, properListItems, termToString, variable } from './term.js';
import {
  ISO_OPERATOR_DEFINITIONS,
  parseClauses,
  parseClausesInto,
  tryParseClausesFastInto,
} from './parser.js';
import { PrologError } from './iso.js';
import { currentWorkingDirectory, fs, path } from './platform.js';

const DEFER_PROGRAM_BUILD = Symbol('deferProgramBuild');
const FAST_PARSE_ABORT = Symbol('fastParseAbort');
const PROGRAM_BUILD_BATCH_SIZE = 16384;
const EMPTY_CLAUSE_BODY = Object.freeze([]);

class CompactBinaryClause {
  constructor(headName, head0Type, head0Name, head1Type, head1Name,
      bodyName, body0Type, body0Name, body1Type, body1Name) {
    this.compactBinary = true;
    this.headName = headName;
    this.head0Type = head0Type;
    this.head0Name = head0Name;
    this.head1Type = head1Type;
    this.head1Name = head1Name;
    this.bodyName = bodyName;
    this.body0Type = body0Type;
    this.body0Name = body0Name;
    this.body1Type = body1Type;
    this.body1Name = body1Name;
  }

  get head() {
    if (!this._head) {
      this._head = compound(this.headName, [
        compactTerm(this.head0Type, this.head0Name),
        compactTerm(this.head1Type, this.head1Name),
      ]);
    }
    return this._head;
  }

  get body() {
    if (this.bodyName == null) return EMPTY_CLAUSE_BODY;
    if (!this._body) {
      this._body = [compound(this.bodyName, [
        compactTerm(this.body0Type, this.body0Name),
        compactTerm(this.body1Type, this.body1Name),
      ])];
    }
    return this._body;
  }
}

function compactTerm(type, name) {
  if (type === VAR) return variable(name);
  if (type === 'number') return numberTerm(name);
  return atom(name);
}

function isCompactBinaryClause(clause) {
  return clause?.compactBinary === true;
}

function compactHeadArgType(clause, index) {
  return index === 0 ? clause.head0Type : clause.head1Type;
}

function compactHeadArgName(clause, index) {
  return index === 0 ? clause.head0Name : clause.head1Name;
}

function compactBodyArgType(clause, index) {
  return index === 0 ? clause.body0Type : clause.body1Type;
}

function compactBodyArgName(clause, index) {
  return index === 0 ? clause.body0Name : clause.body1Name;
}

function clauseBodyLength(clause) {
  return isCompactBinaryClause(clause) ? (clause.bodyName == null ? 0 : 1) : clause.body.length;
}


export class Program {
  constructor(clauses = [], options = {}) {
    this.clauses = [];
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
    this.mutable = false;
    this._negationAnalysis = null;
    if (options[DEFER_PROGRAM_BUILD] === true) return;
    const builder = new ProgramBuilder(options, this);
    builder.addClauses(clauses);
    builder.finish();
  }
  defineOperator(priority, specifier, name) {
    const key = `${specifier}\u0000${name}`;
    if (priority === 0) this.operators.delete(key);
    else this.operators.set(key, { priority, specifier, name });
  }
  static parse(source, options = {}) {
    return buildProgramFromSources([source], options);
  }
  static parseSources(sources = [], options = {}) {
    return buildProgramFromSources(sources, options);
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
      argIndexes: Array.from({ length: arity }, makeArgumentIndex),
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
    this._indexClause(clause, false);
  }
  _indexClause(clause, initialBuild) {
    const head = clause.head;
    if (!initialBuild) assertHeadIsDefinable(head);
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
    if (!initialBuild) {
      group.demandIndexes.clear();
      group.rejectedDemandIndexes.clear();
    }
    group.clauses.push(clause);
    const clausePosition = group.clauses.length - 1;
    for (let i = 0; i < head.arity; i++) indexOne(group.argIndexes[i], head.args[i], clause, group.clauses, clausePosition);
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
      this.mutable = true;
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
        if (isCompactBinaryClause(clause)) {
          if (clause.bodyName != null) {
            const dep = this.groups.get(`${clause.bodyName}/2`);
            if (dep) deps[groupIndex].add(indexByGroup.get(dep));
          }
          continue;
        }
        for (const goal of clause.body) {
          const directKey = directGoalDependencyKey(goal);
          if (directKey) {
            const dep = this.groups.get(directKey);
            if (dep) deps[groupIndex].add(indexByGroup.get(dep));
            continue;
          }
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
    return group.clauses.some((clause) => clauseBodyLength(clause) > 0);
  }
  sourceFactLines(predicateKeys = null) {
    const lines = new Set();
    const env = new Env();
    for (const clause of this.clauses) {
      if (isCompactBinaryClause(clause)) {
        if (clause.bodyName != null) continue;
        if (predicateKeys && !predicateKeys.has(`${clause.headName}/2`)) continue;
        lines.add(`${termToString(clause.head, env, true)}.\n`);
        continue;
      }
      if (clause.body.length !== 0 || (clause.head.type !== ATOM && clause.head.type !== COMPOUND)) continue;
      if (predicateKeys && !predicateKeys.has(`${clause.head.name}/${clause.head.arity}`)) continue;
      lines.add(`${termToString(clause.head, env, true)}.\n`);
    }
    return lines;
  }
}

class ProgramBuilder {
  constructor(options = {}, program = null) {
    this.options = options;
    this.program = program ?? new Program([], { [DEFER_PROGRAM_BUILD]: true });
    this.declaredDynamicIndicators = new Map();
    this.lastGroupKey = null;
    this.lastGroup = null;
    this.finished = false;
  }

  addClauses(clauses) {
    if (this.finished) throw new Error('program builder is already finalized');
    const program = this.program;
    let lastGroupKey = this.lastGroupKey;
    let lastGroup = this.lastGroup;

    for (const clause of clauses) {
      clause.index = program.clauses.length;
      program.clauses.push(clause);

      if (isCompactBinaryClause(clause)) {
        assertPredicateIsDefinable(clause.headName, 2);
        const key = `${clause.headName}/2`;
        let group = key === lastGroupKey ? lastGroup : program.groups.get(key);
        if (!group) {
          group = program.makeGroup(clause.headName, 2);
          program.groups.set(key, group);
        }
        lastGroupKey = key;
        lastGroup = group;
        const clausePosition = group.clauses.length;
        group.clauses.push(clause);
        clause.groundHead = clause.head0Type !== VAR && clause.head1Type !== VAR;
        clause.scalarHead = clause.groundHead;
        if (clause.bodyName != null || !clause.scalarHead) group.scalarFactsOnly = false;
        indexCompactOne(group.argIndexes[0], clause.head0Type, clause.head0Name, clause, group.clauses, clausePosition);
        indexCompactOne(group.argIndexes[1], clause.head1Type, clause.head1Name, clause, group.clauses, clausePosition);
        continue;
      }

      if (!isDirectiveClause(clause)) {
        assertHeadIsDefinable(clause.head);
        const head = clause.head;
        if (head.type !== ATOM && head.type !== COMPOUND) continue;
        const key = `${head.name}/${head.arity}`;
        let group = key === lastGroupKey ? lastGroup : program.groups.get(key);
        if (!group) {
          group = program.makeGroup(head.name, head.arity);
          program.groups.set(key, group);
        }
        lastGroupKey = key;
        lastGroup = group;
        const clausePosition = group.clauses.length;
        group.clauses.push(clause);
        clause.groundHead = termHasNoVariables(head);
        clause.scalarHead = head.type === COMPOUND && head.args.every(isScalar);
        if (clause.body.length !== 0 || !clause.scalarHead) group.scalarFactsOnly = false;
        for (let i = 0; i < head.arity; i++) {
          indexOne(group.argIndexes[i], head.args[i], clause, group.clauses, clausePosition);
        }
        continue;
      }

      this.addDirectiveClause(clause);
    }

    this.lastGroupKey = lastGroupKey;
    this.lastGroup = lastGroup;
  }

  addDirectiveClause(clause) {
    const program = this.program;
    for (const indicator of dynamicDirectiveIndicators(clause)) {
      assertDynamicIndicatorIsDefinable(indicator);
      program.dynamicPredicates.add(indicator.key);
      this.declaredDynamicIndicators.set(indicator.key, indicator);
      const existing = program.groups.get(indicator.key);
      if (existing) existing.dynamic = true;
    }

    const operator = operatorDirective(clause);
    if (operator) {
      for (const name of operator.names) program.defineOperator(operator.priority, operator.specifier, name);
    }

    const directive = clause.head.args[0];
    if (directive?.type === COMPOUND && directive.name === 'initialization' && directive.arity === 1) {
      program.initializations.push(directive.args[0]);
    } else if (directive?.type === COMPOUND && directive.name === 'set_prolog_flag' && directive.arity === 2) {
      program.prologFlagDirectives.push(directive.args);
    } else if (directive?.type === COMPOUND && directive.name === 'char_conversion' && directive.arity === 2) {
      program.charConversionDirectives.push(directive.args);
    }
  }

  finish() {
    if (this.finished) return this.program;
    this.finished = true;
    const program = this.program;

    // A dynamic declaration creates a procedure even when it has no clauses.
    // Calls to that procedure fail normally instead of being treated as calls
    // to an unknown predicate.
    for (const indicator of this.declaredDynamicIndicators.values()) {
      if (!program.groups.has(indicator.key)) {
        program.groups.set(indicator.key, program.makeGroup(indicator.name, indicator.arity));
      }
    }
    program.mutable = program.dynamicPredicates.size > 0;

    // Static indexes are built while clauses stream into the builder. Dynamic
    // updates still rebuild only the affected predicate group.
    program.markRecursivePredicates();
    if (this.options.analyzeNegation === true || this.options.strictNegation === true) {
      program.analyzeNegationStratification();
    }
    if (this.options.strictNegation === true) program.assertStratifiedNegation();
    return program;
  }
}

function buildProgramFromSources(sources, options) {
  // The source-metadata-free path is common for CLI and conformance runs.  It
  // attempts the compact line parser directly into a fresh builder.  Should a
  // source require the full parser (for example because it defines custom
  // operators), the partial builder is simply discarded and the source set is
  // rebuilt once with the general streaming parser.
  if (options.sourceMetadata === false) {
    const builder = new ProgramBuilder(options);
    if (loadSourcesIntoBuilder(builder, sources, options, true)) return builder.finish();
  }

  const builder = new ProgramBuilder(options);
  loadSourcesIntoBuilder(builder, sources, options, false);
  return builder.finish();
}

function loadSourcesIntoBuilder(builder, sources, options, fast) {
  const ensured = new Set();
  try {
    for (const source of sources) {
      const sourceOptions = sourceOptionsFor(source, options);
      const text = typeof source === 'string' ? source : source?.text ?? source?.source ?? '';
      if (!loadSourceIntoBuilder(builder, text, sourceOptions, ensured, fast)) return false;
    }
    return true;
  } catch (error) {
    if (error === FAST_PARSE_ABORT) return false;
    throw error;
  }
}

function sourceOptionsFor(source, options) {
  if (typeof source === 'string') return options;
  return {
    ...options,
    filename: source?.filename ?? '<input>',
    baseDir: source?.baseDir ?? options.baseDir,
  };
}

function loadSourceIntoBuilder(builder, source, options, ensured, fast) {
  const batch = [];
  const flush = () => {
    if (batch.length === 0) return;
    builder.addClauses(batch);
    batch.length = 0;
  };
  const accept = (clause) => {
    const include = includeDirective(clause);
    if (!include) {
      batch.push(clause);
      if (batch.length >= PROGRAM_BUILD_BATCH_SIZE) flush();
      return;
    }
    flush();
    const child = readIncludedSource(include, options, ensured);
    if (!child) return;
    if (!loadSourceIntoBuilder(builder, child.text, child.options, ensured, fast)) {
      throw FAST_PARSE_ABORT;
    }
  };

  if (fast) {
    const acceptBinary = (headName, head0Type, head0Name, head1Type, head1Name,
        bodyName, body0Type, body0Name, body1Type, body1Name) => {
      batch.push(new CompactBinaryClause(
        headName, head0Type, head0Name, head1Type, head1Name,
        bodyName, body0Type, body0Name, body1Type, body1Name,
      ));
      if (batch.length >= PROGRAM_BUILD_BATCH_SIZE) flush();
    };
    const parsed = tryParseClausesFastInto(source, accept, acceptBinary);
    if (parsed) flush();
    return parsed;
  }
  parseClausesInto(source, options, accept);
  flush();
  return true;
}

function includeDirective(clause) {
  if (isCompactBinaryClause(clause) || !isDirectiveClause(clause)) return null;
  const directive = clause.head.args[0];
  return directive?.type === COMPOUND && directive.arity === 1 &&
    (directive.name === 'include' || directive.name === 'ensure_loaded')
    ? directive
    : null;
}

function readIncludedSource(directive, options, ensured) {
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
  if (directive.name === 'ensure_loaded' && ensured.has(filename)) return null;
  if (directive.name === 'ensure_loaded') ensured.add(filename);

  let text;
  try {
    text = fs.readFileSync(filename, 'utf8');
  } catch (_) {
    throw new PrologError('existence_error(source_sink)', atom(designation.name));
  }
  return {
    text,
    options: { ...options, filename, baseDir: path.dirname(filename) },
  };
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

function compactClauseIsDirectRecursive(clause, group) {
  return isCompactBinaryClause(clause) && clause.bodyName === group.name && group.arity === 2;
}

function clauseHasCut(clause) {
  return !isCompactBinaryClause(clause) && clause.body.some(termContainsCut);
}

function clauseIsDirectRecursive(clause, group) {
  if (isCompactBinaryClause(clause)) return compactClauseIsDirectRecursive(clause, group);
  return clause.body.some((goal) =>
    goal.type === COMPOUND && goal.name === group.name && goal.arity === group.arity
  );
}

function componentHasCut(start, deps, groups) {
  const forward = reachableIndexes(start, deps);
  const component = [...forward].filter((index) => reachableIndexes(index, deps).has(start));
  return component.some((index) => {
    const group = groups[index];
    const directRecursive = group.clauses.some((clause) => clauseIsDirectRecursive(clause, group));
    if (!directRecursive) return group.clauses.some(clauseHasCut);
    return group.clauses.some((clause) => clauseIsDirectRecursive(clause, group) && clauseHasCut(clause));
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
  let firstPatternedPosition = -1;
  let firstLinkedInputPosition = -1;
  const changed = new Uint8Array(group.arity);

  for (const clause of group.clauses) {
    if (isCompactBinaryClause(clause)) {
      if (!compactClauseIsDirectRecursive(clause, group)) continue;
      for (let index = 0; index < 2; index++) {
        const headType = compactHeadArgType(clause, index);
        if (headType !== VAR && (firstPatternedPosition < 0 || index < firstPatternedPosition)) {
          firstPatternedPosition = index;
        }
      }
      continue;
    }

    changed.fill(0);
    let recursive = false;
    for (const goal of clause.body) {
      if (goal.type !== COMPOUND || goal.name !== group.name || goal.arity !== group.arity) continue;
      recursive = true;
      for (let index = 0; index < group.arity; index++) {
        if (!sameClauseTerm(clause.head.args[index], goal.args[index])) changed[index] = 1;
      }
    }
    if (!recursive) continue;

    for (let index = 0; index < group.arity; index++) {
      const headArg = clause.head.args[index];
      if (headArg.type !== 'var' && (firstPatternedPosition < 0 || index < firstPatternedPosition)) firstPatternedPosition = index;
      if (headArg.type !== 'var' || changed[index] === 0) continue;
      for (let patternIndex = 0; patternIndex < group.arity; patternIndex++) {
        if (patternIndex === index) continue;
        const pattern = clause.head.args[patternIndex];
        if (pattern.type !== 'var' && termContainsVariable(pattern, headArg.name)) {
          if (firstLinkedInputPosition < 0 || index < firstLinkedInputPosition) firstLinkedInputPosition = index;
          break;
        }
      }
    }
  }
  if (firstLinkedInputPosition >= 0) return [[firstLinkedInputPosition]];
  if (firstPatternedPosition >= 0) return [[firstPatternedPosition]];
  return Array.from({ length: group.arity }, (_, index) => index);
}

function hasLinearNumericRecursion(group) {
  let recursiveClause = null;
  for (const clause of group.clauses) {
    if (isCompactBinaryClause(clause)) {
      if (clause.head0Type !== VAR || clause.head1Type !== VAR) return false;
      if (!compactClauseIsDirectRecursive(clause, group)) continue;
      if (recursiveClause) return false;
      recursiveClause = clause;
      continue;
    }
    for (const arg of clause.head.args) if (arg.type !== 'var') return false;
    let recursive = false;
    for (const goal of clause.body) {
      if (goal.type === COMPOUND && goal.name === group.name && goal.arity === group.arity) {
        recursive = true;
        break;
      }
    }
    if (!recursive) continue;
    if (recursiveClause) return false;
    recursiveClause = clause;
  }
  return recursiveClause != null && !isCompactBinaryClause(recursiveClause) && recursiveClause.body.some((goal) =>
    goal.type === COMPOUND && goal.name === 'is' && goal.arity === 2
  );
}

function isPiAccumulator(group) {
  return group.name === 'pi' && group.arity === 5 && group.clauses.some((clause) =>
    !isCompactBinaryClause(clause) && clause.body.some((goal) => goal.type === COMPOUND && goal.name === 'is' && goal.arity === 2)
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

function directGoalDependencyKey(goal) {
  if (goal.type === ATOM) return `${goal.name}/0`;
  if (goal.type !== COMPOUND) return null;
  if (goal.name === ',' && goal.arity === 2) return null;
  if ((goal.name === '\\+' || goal.name === 'not') && goal.arity === 1) return null;
  if (goal.name === 'once' && goal.arity === 1) return null;
  if (goal.name === 'forall' && goal.arity === 2) return null;
  if ((goal.name === 'findall' || goal.name === 'sumall') && goal.arity === 3) return null;
  if (goal.name === 'countall' && goal.arity === 2) return null;
  if ((goal.name === 'aggregate_min' || goal.name === 'aggregate_max') && goal.arity === 5) return null;
  return `${goal.name}/${goal.arity}`;
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

function makeArgumentIndex() {
  return {
    atomBuckets: new Map(),
    stringBuckets: new Map(),
    numberBuckets: new Map(),
    fallback: [],
    sawScalar: false,
  };
}

function scalarBuckets(index, term) {
  if (term.type === ATOM) return index.atomBuckets;
  if (term.type === 'string') return index.stringBuckets;
  return index.numberBuckets;
}

function argumentBucket(index, term) {
  return scalarBuckets(index, term).get(term.name) ?? null;
}

function addArgumentBucket(index, term, clause) {
  addClauseBucket(scalarBuckets(index, term), term.name, clause);
}

function scalarIndexKey(term) {
  return `${term.type}\u0000${term.name}`;
}

function addClauseBucket(buckets, key, clause) {
  const existing = buckets.get(key);
  if (existing == null) buckets.set(key, clause);
  else if (Array.isArray(existing)) existing.push(clause);
  else buckets.set(key, [existing, clause]);
}

function clauseCollectionLength(clauses) {
  return clauses == null ? 0 : Array.isArray(clauses) ? clauses.length : 1;
}

function clauseCollectionAt(clauses, index) {
  return Array.isArray(clauses) ? clauses[index] : index === 0 ? clauses : undefined;
}

function compactScalarBuckets(index, type) {
  if (type === ATOM) return index.atomBuckets;
  if (type === 'number') return index.numberBuckets;
  return index.stringBuckets;
}

function indexCompactOne(index, type, name, clause, clauses = null, clausePosition = -1) {
  if (type !== VAR) {
    if (!index.sawScalar) {
      index.sawScalar = true;
      if (clauses && clausePosition > 0) index.fallback = clauses.slice(0, clausePosition);
    }
    addClauseBucket(compactScalarBuckets(index, type), name, clause);
  } else if (index.sawScalar) {
    index.fallback.push(clause);
  }
}

function indexOne(index, arg, clause, clauses = null, clausePosition = -1) {
  if (isScalar(arg)) {
    if (!index.sawScalar) {
      index.sawScalar = true;
      if (clauses && clausePosition > 0) index.fallback = clauses.slice(0, clausePosition);
    }
    addArgumentBucket(index, arg, clause);
  } else if (index.sawScalar) {
    index.fallback.push(clause);
  }
}

function indexFallback(index, group) {
  return index.sawScalar ? index.fallback : group.clauses;
}

function rebuildGroupIndexes(group) {
  group.argIndexes = Array.from({ length: group.arity }, makeArgumentIndex);
  group.demandIndexes.clear();
  group.rejectedDemandIndexes.clear();
  group.scalarFactsOnly = true;
  for (let clausePosition = 0; clausePosition < group.clauses.length; clausePosition++) {
    const clause = group.clauses[clausePosition];
    if (isCompactBinaryClause(clause)) {
      clause.groundHead = clause.head0Type !== VAR && clause.head1Type !== VAR;
      clause.scalarHead = clause.groundHead;
      if (clause.bodyName != null || !clause.scalarHead) group.scalarFactsOnly = false;
      indexCompactOne(group.argIndexes[0], clause.head0Type, clause.head0Name, clause, group.clauses, clausePosition);
      indexCompactOne(group.argIndexes[1], clause.head1Type, clause.head1Name, clause, group.clauses, clausePosition);
      continue;
    }
    clause.groundHead = termHasNoVariables(clause.head);
    clause.scalarHead = clause.head.type === COMPOUND && clause.head.args.every(isScalar);
    if (clause.body.length !== 0 || !clause.scalarHead) group.scalarFactsOnly = false;
    for (let i = 0; i < group.arity; i++) indexOne(group.argIndexes[i], clause.head.args[i], clause, group.clauses, clausePosition);
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
    if (isCompactBinaryClause(clause)) {
      const values = positions.map((position) => compactTerm(
        compactHeadArgType(clause, position), compactHeadArgName(clause, position)));
      if (!values.every(isScalar)) {
        index.fallback.push(clause);
        continue;
      }
      addClauseBucket(index.buckets, demandValueKey(values), clause);
      continue;
    }
    const values = positions.map((position) => clause.head.args[position]);
    if (!values.every(isScalar)) {
      index.fallback.push(clause);
      continue;
    }
    const key = demandValueKey(values);
    addClauseBucket(index.buckets, key, clause);
  }
  return index;
}

function mergeClausesInSourceOrder(primary, fallback) {
  const primaryLength = clauseCollectionLength(primary);
  if (fallback.length === 0) return primary;
  if (primaryLength === 0) return fallback;
  const merged = [];
  let left = 0;
  let right = 0;
  while (left < primaryLength && right < fallback.length) {
    const primaryClause = clauseCollectionAt(primary, left);
    if (primaryClause.index < fallback[right].index) {
      merged.push(primaryClause);
      left++;
    } else {
      merged.push(fallback[right++]);
    }
  }
  while (left < primaryLength) merged.push(clauseCollectionAt(primary, left++));
  while (right < fallback.length) merged.push(fallback[right++]);
  return merged;
}


export function selectGroundClauseCandidates(group, goal) {
  if (goal.type !== COMPOUND || group.clauses.length < DEMAND_INDEX_MIN_CLAUSES) return group.clauses;
  let bestPrimary = null;
  let bestFallback = null;
  let bestLength = group.clauses.length;
  for (let i = 0; i < goal.arity; i++) {
    const value = goal.args[i];
    if (!isScalar(value)) continue;
    const index = group.argIndexes[i];
    const fallback = indexFallback(index, group);
    if (fallback.length / group.clauses.length > INDEX_MAX_VAR_FRACTION) continue;
    const primary = argumentBucket(index, value);
    const length = clauseCollectionLength(primary) + fallback.length;
    if (group.clauses.length / Math.max(1, length) < INDEX_MIN_SPEEDUP) continue;
    if (length < bestLength) {
      bestPrimary = primary;
      bestFallback = fallback;
      bestLength = length;
    }
  }
  if (bestFallback == null) return group.clauses;
  if (bestFallback.length === 0) return bestPrimary;
  if (clauseCollectionLength(bestPrimary) === 0) return bestFallback;
  return mergeClausesInSourceOrder(bestPrimary, bestFallback);
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
    const fallback = indexFallback(index, group);
    const parts = { primary: argumentBucket(index, values[i]), fallback };
    const length = clauseCollectionLength(parts.primary) + parts.fallback.length;
    if (fallback.length / group.clauses.length > INDEX_MAX_VAR_FRACTION) continue;
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
    const length = clauseCollectionLength(parts.primary) + parts.fallback.length;
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
      : clauseCollectionLength(bestParts.primary) === 0 ? bestParts.fallback
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
  const bucket = index.buckets.get(demandValueKey(values)) ?? null;
  return { primary: bucket, fallback: index.fallback };
}

export function makeProgram(source, options = {}) {
  return Program.parse(source, options);
}

export function parseSourceClauses(source, options = {}) {
  return parseClauses(source, options);
}
