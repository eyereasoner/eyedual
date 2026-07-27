// Program representation and clause indexing.
// Indexes are deliberately conservative: they speed up common scalar arguments but never replace unification as the final check.
import { ATOM, COMPOUND, Env, deref, flattenConjunction, isScalar, properListItems, termToString } from './term.js';
import { parseClauses } from './parser.js';

export class Program {
  constructor(clauses = [], options = {}) {
    this.clauses = clauses;
    this.groups = new Map();
    this.queries = [];
    this.fuses = [];
    for (let index = 0; index < this.clauses.length; index++) {
      const clause = this.clauses[index];
      clause.index = index;
      if (isInferenceFuse(clause)) {
        this.fuses.push(clause);
        continue;
      }
      if (isQueryDeclaration(clause)) {
        this.queries.push(clause.head.args[0]);
        continue;
      }
      this.indexClause(clause);
    }
    this._negationAnalysis = null;
    this.applyDeclarations(options);
  }
  static parse(source, options = {}) {
    return new Program(parseSourceClauses(source, options), options);
  }
  static parseSources(sources = [], options = {}) {
    const clauses = [];
    for (const source of sources) {
      const parsed = typeof source === 'string'
        ? parseSourceClauses(source, options)
        : parseSourceClauses(source?.text ?? source?.source ?? '', { ...options, filename: source?.filename ?? '<input>' });
      for (const clause of parsed) clauses.push(clause);
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
      mode: null,
      determinism: null,
      recursive: false,
      tableInputPositions: [],
      scalarFactsOnly: true,
      negationStratum: null,
    };
    return group;
  }
  indexClause(clause) {
    const head = clause.head;
    if (head.type !== COMPOUND) return;
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
  applyDeclarations(options = {}) {
    for (const clause of this.clauses) {
      const h = clause.head;
      if (clause.body.length !== 0 || h.type !== COMPOUND) continue;

      if (h.arity === 2) {
        const indicator = declarationIndicator(h.args[0], h.args[1]);
        if (!indicator) continue;
        const group = this.groups.get(indicator.key);
        if ((h.name === 'det' || h.name === 'semidet') && group) {
          group.determinism = h.name;
        }
        continue;
      }

      if (h.name === 'mode' && h.arity === 3) {
        const indicator = declarationIndicator(h.args[0], h.args[1]);
        if (!indicator) continue;
        const modes = declarationModes(h.args[2]);
        if (modes && modes.length === indicator.arity) {
          const group = this.groups.get(indicator.key);
          if (group) group.mode = modes;
        }
      }
    }
    // Hybrid planning is part of normal execution, so dependency analysis is
    // always performed. `markRecursive` is retained as a compatible parse
    // option but no longer disables the engine's automatic table decisions.
    this.markRecursivePredicates();
    if (options.analyzeNegation === true || options.strictNegation === true) this.analyzeNegationStratification();
    if (options.strictNegation === true) this.assertStratifiedNegation();
  }
  markRecursivePredicates() {
    // Recursion is a group-level diagnostic hint. It is computed from predicate
    // dependencies rather than from individual clauses when callers explicitly ask
    // for it.
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
      group.tabled = recursive && !componentHasNegativeEdge(start, deps, negativeEdges);
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
      if (clause.body.length !== 0 || clause.head.type !== COMPOUND || isQueryDeclaration(clause)) continue;
      if (predicateKeys && !predicateKeys.has(`${clause.head.name}/${clause.head.arity}`)) continue;
      lines.add(`${termToString(clause.head, env, true)}.\n`);
    }
    return lines;
  }
  queryGoals() {
    const groupOrder = new Map([...this.groups.keys()].map((key, index) => [key, index]));
    return this.queries
      .map((goal, index) => ({ goal, index }))
      .sort((left, right) => {
        const leftOrder = groupOrder.get(`${left.goal.name}/${left.goal.arity}`) ?? Number.MAX_SAFE_INTEGER;
        const rightOrder = groupOrder.get(`${right.goal.name}/${right.goal.arity}`) ?? Number.MAX_SAFE_INTEGER;
        return leftOrder - rightOrder || left.index - right.index;
      })
      .map(({ goal }) => goal);
  }
}

function isQueryDeclaration(clause) {
  return clause.body.length === 0
    && clause.head.type === COMPOUND
    && clause.head.name === 'query'
    && clause.head.arity === 1;
}

function isInferenceFuse(clause) {
  return clause.head.type === ATOM && clause.head.name === 'false';
}

function componentHasNegativeEdge(start, deps, negativeEdges) {
  const forward = reachableIndexes(start, deps);
  const component = new Set([...forward].filter((index) => reachableIndexes(index, deps).has(start)));
  return negativeEdges.some(([from, to]) => component.has(from) && component.has(to));
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

function declarationIndicator(name, arity) {
  if (name?.type !== ATOM || arity?.type !== 'number') return null;
  if (!/^\d+$/.test(arity.name)) return null;
  const arityNumber = Number(arity.name);
  return { name: name.name, arity: arityNumber, key: `${name.name}/${arityNumber}` };
}

function declarationModes(term) {
  const items = properListItems(term, new Env());
  if (!items) return null;
  const modes = [];
  for (const item of items) {
    if (item.type !== ATOM) return null;
    if (!['in', 'out', 'any'].includes(item.name)) return null;
    modes.push(item.name);
  }
  return modes;
}

// These defaults mirror SWI-Prolog's JITI admission policy: small predicates
// stay linear, a hash must promise a useful speedup, variable-heavy positions
// are rejected, and a multi-argument hash must substantially beat singles.
const DEMAND_INDEX_MIN_CLAUSES = 10;
const INDEX_MIN_SPEEDUP = 1.5;
const INDEX_MAX_VAR_FRACTION = 0.1;
const MULTI_INDEX_MIN_SPEEDUP_RATIO = 3;

function indexOne(index, arg, clause) {
  if (isScalar(arg)) {
    const bucket = index.buckets.get(arg.name);
    if (bucket) bucket.push(clause);
    else index.buckets.set(arg.name, [clause]);
  } else {
    index.fallback.push(clause);
  }
}

function demandIndexKey(positions) {
  return positions.join(',');
}

function demandValueKey(values) {
  // Scalar equality in Eyepl is lexical, so the scalar type is intentionally
  // absent here. Length prefixes make the composite key unambiguous.
  if (values.length === 1) return values[0].name;
  return values.map((value) => `${value.name.length}:${value.name}`).join('');
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
    const parts = { primary: index.buckets.get(values[i].name) ?? [], fallback: index.fallback };
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
  const best = bestParts
    ? mergeClausesInSourceOrder(bestParts.primary, bestParts.fallback)
    : group.clauses;
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
