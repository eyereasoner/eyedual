// Eyepl standard library implemented entirely as native JavaScript builtins.
// The single registry is shared by Node, embedders, and the browser playground.
import {
  ATOM,
  COMPOUND,
  Env,
  atom,
  compareIntegerText,
  compareTerms,
  compound,
  cons,
  copyResolved,
  deref,
  emptyList,
  isCons,
  isEmptyList,
  isDecimalInteger,
  lexicalValue,
  listFromItems,
  numberTerm,
  numberTextFromDouble,
  parseFiniteNumber,
  properListItems,
  stringTerm,
  termToString,
  unify,
  variable,
} from './term.js';
import {
  BuiltinRegistry,
  PrologError,
  arithmeticValueTerm,
  compareArithmeticValues,
  evaluateArithmetic,
  isoBuiltins,
} from './iso.js';

// Numeric builtins for integer-preserving arithmetic, floating point functions, comparisons, and ranges.
// The code keeps BigInt paths where possible so large Eyepl integers remain exact.

const unaryNames = ['tan', 'asin', 'acos'];
const binaryNames = ['atan2'];
const compareNames = ['lt', 'gt', 'le', 'ge'];

export const arithmeticBuiltins = {
  register(registry) {
    for (const name of unaryNames) registry.add(name, 2, unary(name), { deterministic: true });
    for (const name of binaryNames) registry.add(name, 3, binary(name), { deterministic: true });
    for (const name of compareNames) registry.add(name, 2, compare(name), { deterministic: true });
    registry.add('between', 3, between, { standardLibrary: true });
    registry.add('smallest_divisor_from', 3, smallestDivisorFrom, {
      deterministic: true,
      standardLibrary: true,
    });
  }
};

function* between({ goal, env }) {
  const lowText = lexicalValue(goal.args[0], env);
  const highText = lexicalValue(goal.args[1], env);
  if (!isDecimalInteger(lowText) || !isDecimalInteger(highText)) return;
  const low = BigInt(lowText);
  const high = BigInt(highText);
  if (low > high) return;
  const output = deref(goal.args[2], env);
  if (output.type !== 'var') {
    const valueText = lexicalValue(output, env);
    if (!isDecimalInteger(valueText)) return;
    const value = BigInt(valueText);
    if (value >= low && value <= high) yield env;
    return;
  }
  for (let value = low; value <= high; value++) {
    const next = env.clone();
    next.bind(output.name, numberTerm(value.toString()));
    yield next;
  }
}

function* smallestDivisorFrom({ goal, env }) {
  const nText = lexicalValue(goal.args[0], env);
  const startText = lexicalValue(goal.args[1], env);
  if (!isDecimalInteger(nText) || !isDecimalInteger(startText)) return;
  const n = BigInt(nText);
  const start = BigInt(startText);
  if (n < 0n || start <= 0n) return;
  let divisor = n;
  for (let candidate = start; candidate <= n / candidate; candidate++) {
    if (n % candidate === 0n) {
      divisor = candidate;
      break;
    }
  }
  const next = env.clone();
  if (unify(goal.args[2], numberTerm(divisor.toString()), next)) yield next;
}

function unary(name) {
  return function* ({ goal, env }) {
    const text = lexicalValue(goal.args[0], env);
    if (text == null) return;
    const input = parseFiniteNumber(text);
    if (input == null) return;
    const value = name === 'tan' ? Math.tan(input) : name === 'asin' ? Math.asin(input) : Math.acos(input);
    const out = numberTextFromDouble(value);
    const next = env.clone();
    if (out != null && unify(goal.args[1], numberTerm(out), next)) yield next;
  };
}

function binary(name) {
  return function* ({ goal, env }) {
    const leftText = lexicalValue(goal.args[0], env);
    const rightText = lexicalValue(goal.args[1], env);
    if (leftText == null || rightText == null) return;
    const a = parseFiniteNumber(leftText), b = parseFiniteNumber(rightText);
    if (a == null || b == null) return;
    const out = numberTextFromDouble(Math.atan2(a, b));
    const next = env.clone();
    if (out != null && unify(goal.args[2], numberTerm(out), next)) yield next;
  };
}

function compare(name) {
  return function* ({ goal, env }) {
    const left = lexicalValue(goal.args[0], env);
    const right = lexicalValue(goal.args[1], env);
    if (left == null || right == null) return;
    const cmp = compareLexicalOrNumeric(left, right);
    const pass = name === 'lt' ? cmp < 0 : name === 'gt' ? cmp > 0 : name === 'le' ? cmp <= 0 : cmp >= 0;
    if (pass) yield env;
  };
}

export function compareLexicalOrNumeric(left, right) {
  if (isDecimalInteger(left) && isDecimalInteger(right)) return compareIntegerText(left, right);
  const dur = compareDuration(left, right);
  if (dur != null) return dur;
  const a = parseFiniteNumber(left), b = parseFiniteNumber(right);
  if (a != null && b != null) return a < b ? -1 : a > b ? 1 : 0;
  return left < right ? -1 : left > right ? 1 : 0;
}

function compareDuration(a, b) {
  const pa = parseDuration(a), pb = parseDuration(b);
  if (!pa || !pb) return null;
  for (let i = 0; i < 3; i++) if (pa[i] !== pb[i]) return pa[i] < pb[i] ? -1 : 1;
  return 0;
}
function parseDuration(text) {
  const m = /^P(?:(\d+)Y)?(?:(\d+)M)?(?:(\d+)D)?$/.exec(text);
  if (!m || (!m[1] && !m[2] && !m[3])) return null;
  return [Number(m[1] ?? 0), Number(m[2] ?? 0), Number(m[3] ?? 0)];
}


// Core relational builtins that do not naturally belong to arithmetic, strings, lists, or aggregation.
// They are deterministic filters/projections and should avoid enumerating additional answers.

export const coreBuiltins = {
  register(registry) {
    registry.add('local_time', 1, function* ({ goal, env }) {
      const next = env.clone();
      if (unify(goal.args[0], stringTerm(localDateText()), next)) yield next;
    }, { deterministic: true });

    registry.add('difference', 3, function* ({ goal, env }) {
      const endText = lexicalValue(goal.args[0], env);
      const startText = lexicalValue(goal.args[1], env);
      if (!endText || !startText) return;
      const end = parseISODate(endText);
      const start = parseISODate(startText);
      if (!end || !start || compareDateParts(end, start) < 0) return;
      let [ey, em, ed] = end;
      const [sy, sm, sd] = start;
      if (ed < sd) {
        let bm = em - 1;
        let by = ey;
        if (bm === 0) { bm = 12; by--; }
        ed += daysInMonth(by, bm);
        em--;
        if (em === 0) { em = 12; ey--; }
      }
      if (em < sm) { em += 12; ey--; }
      const duration = formatDuration(ey - sy, em - sm, ed - sd);
      const next = env.clone();
      if (unify(goal.args[2], stringTerm(duration), next)) yield next;
    }, { deterministic: true });
  }
};

export const metaCallBuiltins = {
  register(registry) {
    registry.add('call', 3, callWithTwoExtraArguments);
    registry.add('maplist', 3, maplistTwoLists, {
      standardLibrary: true,
      shouldUse: ({ solver }) => solver.program.findGroup('maplist', 3) == null,
    });
  }
};

function* callWithTwoExtraArguments({ solver, goal, env }) {
  const closure = deref(goal.args[0], env);
  if (closure.type === 'var') throw new PrologError('instantiation_error');
  if (closure.type !== ATOM && closure.type !== COMPOUND) {
    throw new PrologError('type_error(callable)', closure);
  }
  const invoked = compound(closure.name, [
    ...(closure.type === COMPOUND ? closure.args : []),
    goal.args[1],
    goal.args[2],
  ]);
  const child = solver.cloneForInnerGoal();
  try {
    yield* child.solve([invoked], env, 0);
  } finally {
    solver.absorbStatsFrom(child);
  }
}

function* maplistTwoLists({ solver, goal, env }) {
  const input = properListItems(goal.args[1], env);
  if (input == null) return;
  let output = properListItems(goal.args[2], env);
  let next = env;
  if (output == null) {
    if (deref(goal.args[2], env).type !== 'var') return;
    const id = ++generatedListVariable;
    output = input.map((_, index) => variable(`_maplist_${id}_${index}`));
    next = env.clone();
    if (!unify(goal.args[2], listFromItems(output), next)) return;
  }
  if (input.length !== output.length) return;
  const closure = deref(goal.args[0], next);
  if (closure.type === 'var') throw new PrologError('instantiation_error');
  if (closure.type !== ATOM && closure.type !== COMPOUND) {
    throw new PrologError('type_error(callable)', closure);
  }
  const prefix = closure.type === COMPOUND ? closure.args : [];
  function* solveItem(index, current) {
    if (index === input.length) {
      yield current;
      return;
    }
    const invoked = compound(closure.name, [...prefix, input[index], output[index]]);
    const child = solver.cloneForInnerGoal();
    try {
      for (const answer of child.solve([invoked], current, 0)) {
        yield* solveItem(index + 1, answer);
      }
    } finally {
      solver.absorbStatsFrom(child);
    }
  }
  yield* solveItem(0, next);
}


function localDateText() {
  const fixed = typeof process !== 'undefined' ? process.env?.EYEPL_LOCAL_TIME : null;
  if (fixed) return fixed;

  const now = new Date();
  const yyyy = now.getFullYear();
  const mm = String(now.getMonth() + 1).padStart(2, '0');
  const dd = String(now.getDate()).padStart(2, '0');
  return `${yyyy}-${mm}-${dd}`;
}

function parseISODate(text) {
  const m = /^(\d{4})-(\d{2})-(\d{2})/.exec(text);
  if (!m) return null;
  const y = Number(m[1]), mo = Number(m[2]), d = Number(m[3]);
  if (mo < 1 || mo > 12 || d < 1 || d > daysInMonth(y, mo)) return null;
  return [y, mo, d];
}
function daysInMonth(y, m) {
  return [0,31,((y%4===0&&y%100!==0)||y%400===0)?29:28,31,30,31,30,31,31,30,31,30,31][m] ?? 0;
}
function compareDateParts(a, b) {
  for (let i = 0; i < 3; i++) if (a[i] !== b[i]) return a[i] < b[i] ? -1 : 1;
  return 0;
}
function formatDuration(y, m, d) {
  if (y === 0 && m === 0 && d === 0) return 'P0D';
  return `P${y ? `${y}Y` : ''}${m ? `${m}M` : ''}${d ? `${d}D` : ''}`;
}


// String builtins.
// They mostly project from already-ground terms to avoid guessing string domains.

export const stringBuiltins = {
  register(registry) {
    registry.add('matches', 3, matchCaptures, { deterministic: true });
    registry.add('split', 3, split, { deterministic: true, fallbackWhenNotReady: true, ready: firstTwoLexicalReady });
    registry.add('replace', 4, replace, { deterministic: true, fallbackWhenNotReady: true, ready: firstThreeLexicalReady });
    registry.add('lowercase', 2, caseFold('lower'), { deterministic: true, fallbackWhenNotReady: true, ready: firstLexicalReady });
    registry.add('uppercase', 2, caseFold('upper'), { deterministic: true, fallbackWhenNotReady: true, ready: firstLexicalReady });
    registry.add('trim', 2, trim, { deterministic: true, fallbackWhenNotReady: true, ready: firstLexicalReady });
    registry.add('number_string', 2, numberString, { deterministic: true, fallbackWhenNotReady: true, ready: numberStringReady });
    registry.add('atom_string', 2, atomString, { deterministic: true, fallbackWhenNotReady: true, ready: atomStringReady });
    registry.add('term_string', 2, termString, { deterministic: true, fallbackWhenNotReady: true, ready: firstNonvarReady });
  }
};



function firstLexicalReady(goal, env) {
  return lexicalValue(goal.args[0], env) !== null;
}

function firstTwoLexicalReady(goal, env) {
  return lexicalValue(goal.args[0], env) !== null && lexicalValue(goal.args[1], env) !== null;
}

function firstThreeLexicalReady(goal, env) {
  return firstTwoLexicalReady(goal, env) && lexicalValue(goal.args[2], env) !== null;
}

function numberStringReady(goal, env) {
  const left = deref(goal.args[0], env);
  const right = deref(goal.args[1], env);
  return left.type === 'number' || right.type === 'string' || right.type === 'atom';
}

function atomStringReady(goal, env) {
  const left = deref(goal.args[0], env);
  const right = deref(goal.args[1], env);
  return left.type === 'atom' || right.type === 'string' || right.type === 'atom' || right.type === 'number';
}

function firstNonvarReady(goal, env) {
  return deref(goal.args[0], env).type !== 'var';
}

function* matchCaptures({ goal, env }) {
  const text = lexicalValue(goal.args[0], env);
  const pattern = lexicalValue(goal.args[1], env);
  if (text == null || pattern == null) return;

  let match;
  try {
    match = new RegExp(pattern).exec(text);
  } catch (_) {
    return;
  }
  if (!match?.groups) return;

  const context = contextFromGroups(match.groups);
  if (context == null) return;

  const next = env.clone();
  if (unify(goal.args[2], context, next)) yield next;
}

function* split({ goal, env }) {
  const text = lexicalValue(goal.args[0], env);
  const separator = lexicalValue(goal.args[1], env);
  if (text == null || separator == null) return;
  const parts = text.split(separator).map(stringTerm);
  const next = env.clone();
  if (unify(goal.args[2], listFromItems(parts), next)) yield next;
}

function* replace({ goal, env }) {
  const text = lexicalValue(goal.args[0], env);
  const search = lexicalValue(goal.args[1], env);
  const replacement = lexicalValue(goal.args[2], env);
  if (text == null || search == null || replacement == null) return;
  const out = search === '' ? text : text.split(search).join(replacement);
  const next = env.clone();
  if (unify(goal.args[3], stringTerm(out), next)) yield next;
}

function caseFold(direction) {
  return function* ({ goal, env }) {
    const text = lexicalValue(goal.args[0], env);
    if (text == null) return;
    const next = env.clone();
    const out = direction === 'lower' ? text.toLowerCase() : text.toUpperCase();
    if (unify(goal.args[1], stringTerm(out), next)) yield next;
  };
}

function* trim({ goal, env }) {
  const text = lexicalValue(goal.args[0], env);
  if (text == null) return;
  const next = env.clone();
  if (unify(goal.args[1], stringTerm(text.trim()), next)) yield next;
}

function* numberString({ goal, env }) {
  const left = deref(goal.args[0], env);
  const right = deref(goal.args[1], env);
  const next = env.clone();
  if (left.type === 'number') {
    if (unify(goal.args[1], stringTerm(left.name), next)) yield next;
    return;
  }
  if (right.type === 'string' || right.type === 'atom') {
    if (!numericText(right.name)) return;
    if (unify(goal.args[0], numberTerm(right.name), next)) yield next;
  }
}

function* atomString({ goal, env }) {
  const left = deref(goal.args[0], env);
  const right = deref(goal.args[1], env);
  const next = env.clone();
  if (left.type === 'atom') {
    if (unify(goal.args[1], stringTerm(left.name), next)) yield next;
    return;
  }
  if (right.type === 'string' || right.type === 'atom' || right.type === 'number') {
    if (unify(goal.args[0], atom(right.name), next)) yield next;
  }
}

function* termString({ goal, env }) {
  const term = deref(goal.args[0], env);
  if (term.type === 'var') return;
  const next = env.clone();
  if (unify(goal.args[1], stringTerm(termToString(term, env, true)), next)) yield next;
}

function contextFromGroups(groups) {
  const terms = [];
  for (const [name, value] of Object.entries(groups)) {
    if (value !== undefined) terms.push(compound(name, [stringTerm(value)]));
  }
  if (terms.length === 0) return null;

  let context = terms[terms.length - 1];
  for (let i = terms.length - 2; i >= 0; i--) context = compound(',', [terms[i], context]);
  return context;
}

function numericText(text) {
  return isDecimalInteger(text) || parseFiniteNumber(text) != null;
}
// Native standard-library relations.
// These predicates used to be parsed from bundled Prolog source. Keeping them
// in the builtin registry removes startup parsing, avoids browser module/cache
// duplication, and gives the hot list/aggregation paths direct JavaScript
// implementations while preserving the established relation surface.

export const standardBuiltins = {
  register(registry) {
    const relation = (name, arity, handler, options = {}) => registry.add(name, arity, handler, {
      ...options,
      standardLibrary: true,
    });
    const accelerator = (name, arity, handler, options = {}) => registry.add(name, arity, handler, {
      ...options,
      standardLibrary: true,
    });

    relation('append', 3, appendBuiltin);
    relation('str_concat', 3, strConcatBuiltin, { deterministic: true });
    accelerator('contains', 2, containsBuiltin, {
      deterministic: true,
      ready: twoLexicalInputsReady,
      fallbackWhenNotReady: true,
    });
    accelerator('matches', 2, matchesBuiltin, {
      deterministic: true,
      ready: twoLexicalInputsReady,
      fallbackWhenNotReady: true,
    });
    relation('matches_alternative', 2, matchesAlternativeBuiltin);
    relation('join', 3, joinBuiltin, { deterministic: true });
    relation('join_atoms', 4, joinAtomsBuiltin, { deterministic: true });
    relation('substring', 4, substringBuiltin, { deterministic: true });

    accelerator('member', 2, memberBuiltin, { shouldUse: ({ solver, goal, env }) => solver.program.findGroup('member', 2) == null || listTermReady(goal.args[1], env) });
    accelerator('select', 3, selectBuiltin, { shouldUse: ({ solver, goal, env }) => solver.program.findGroup('select', 3) == null || listTermReady(goal.args[1], env) });
    relation('head', 2, headBuiltin, { deterministic: true, shouldUse: ({ solver, goal, env }) => solver.program.findGroup('head', 2) == null || listTermReady(goal.args[0], env) });
    relation('rest', 2, restBuiltin, { deterministic: true, shouldUse: ({ solver, goal, env }) => solver.program.findGroup('rest', 2) == null || listTermReady(goal.args[0], env) });
    relation('last', 2, lastBuiltin, { deterministic: true, shouldUse: ({ solver, goal, env }) => solver.program.findGroup('last', 2) == null || listTermReady(goal.args[0], env) });
    relation('nth0', 3, nth0Builtin);
    relation('nth1', 3, nth1Builtin);
    relation('set_nth0', 4, setNth0Builtin, { deterministic: true });
    relation('take', 3, takeBuiltin, { deterministic: true });
    relation('drop', 3, dropBuiltin, { deterministic: true });
    relation('slice', 4, sliceBuiltin, { deterministic: true });
    accelerator('reverse', 2, reverseBuiltin, { deterministic: true, shouldUse: ({ solver, goal, env }) => solver.program.findGroup('reverse', 2) == null || reverseReady(goal, env) });
    relation('reverse_acc', 3, reverseAccBuiltin, { deterministic: true });
    accelerator('length', 2, lengthBuiltin, { deterministic: true, shouldUse: ({ solver, goal, env }) => solver.program.findGroup('length', 2) == null || properListItems(goal.args[0], env) != null });
    relation('sum_list', 2, sumListBuiltin, { deterministic: true });
    relation('min_list', 2, minListBuiltin, { deterministic: true });
    relation('min_list_acc', 3, minListAccBuiltin, { deterministic: true });
    relation('max_list', 2, maxListBuiltin, { deterministic: true });
    relation('max_list_acc', 3, maxListAccBuiltin, { deterministic: true });
    relation('not_member', 2, notMemberBuiltin, { deterministic: true });
    relation('list_to_set', 2, listToSetBuiltin, { deterministic: true });
    accelerator('sort', 2, sortBuiltin, { deterministic: true });
    relation('sort_acc', 3, sortAccBuiltin, { deterministic: true });
    relation('insert_unique', 3, insertUniqueBuiltin, { deterministic: true });

    accelerator('countall', 2, countallBuiltin, { deterministic: true });
    relation('sumall', 3, sumallBuiltin, { deterministic: true });
    relation('aggregate_min', 5, aggregateBuiltin(-1), { deterministic: true });
    relation('aggregate_min_pairs', 3, aggregatePairsBuiltin(-1), { deterministic: true });
    relation('aggregate_min_acc', 5, aggregateAccBuiltin(-1), { deterministic: true });
    relation('aggregate_max', 5, aggregateBuiltin(1), { deterministic: true });
    relation('aggregate_max_pairs', 3, aggregatePairsBuiltin(1), { deterministic: true });
    relation('aggregate_max_acc', 5, aggregateAccBuiltin(1), { deterministic: true });

    relation('between_range', 3, betweenRangeBuiltin);
    relation('min', 3, numericChoiceBuiltin(-1), { deterministic: true });
    relation('max', 3, numericChoiceBuiltin(1), { deterministic: true });
    relation('holds', 2, holdsBuiltin);
    relation('holds', 3, holdsPartsBuiltin);
  }
};
let nativeVariableCounter = 0;
let generatedListVariable = 0;

function nativeVariable(prefix) {
  return variable(`_${prefix}_${++nativeVariableCounter}`);
}

function listSpine(term, env) {
  const items = [];
  let tail = deref(term, env);
  const seen = new Set();
  while (isCons(tail)) {
    if (seen.has(tail)) return null;
    seen.add(tail);
    items.push(tail.args[0]);
    tail = deref(tail.args[1], env);
  }
  return { items, tail };
}

function listTermReady(term, env) {
  const resolved = deref(term, env);
  return isCons(resolved) || isEmptyList(resolved);
}

function lengthReady(goal, env) {
  if (listTermReady(goal.args[0], env)) return true;
  const list = deref(goal.args[0], env);
  const size = deref(goal.args[1], env);
  return list.type === 'var' && size.type === 'number' && isDecimalInteger(size.name);
}

function reverseReady(goal, env) {
  return properListItems(goal.args[0], env) != null || properListItems(goal.args[1], env) != null;
}

function isProperSpine(spine) {
  return spine != null && isEmptyList(spine.tail);
}

function exactIdentity(left, right, env) {
  left = deref(left, env);
  right = deref(right, env);
  if (left.type !== right.type || left.name !== right.name || left.arity !== right.arity) return false;
  if (left.type === 'var') return left.name === right.name;
  for (let index = 0; index < left.arity; index++) {
    if (!exactIdentity(left.args[index], right.args[index], env)) return false;
  }
  return true;
}

function* appendBuiltin({ goal, env }) {
  const [left, right, whole] = goal.args;
  const leftSpine = listSpine(left, env);
  if (isProperSpine(leftSpine)) {
    const next = env.clone();
    if (unify(whole, listFromItems(leftSpine.items, 0, leftSpine.items.length, right), next)) yield next;
    return;
  }

  const wholeSpine = listSpine(whole, env);
  if (wholeSpine && wholeSpine.tail.type !== 'var') {
    for (let split = 0; split <= wholeSpine.items.length; split++) {
      const prefix = listFromItems(wholeSpine.items, 0, split);
      const suffix = listFromItems(wholeSpine.items, split, wholeSpine.items.length, wholeSpine.tail);
      const next = env.clone();
      if (unify(left, prefix, next) && unify(right, suffix, next)) yield next;
    }
    return;
  }

  yield* appendRelational(left, right, whole, env);
}

function* appendRelational(left, right, whole, env) {
  const base = env.clone();
  if (unify(left, emptyList(), base) && unify(right, whole, base)) yield base;

  const item = nativeVariable('append_item');
  const leftTail = nativeVariable('append_left');
  const wholeTail = nativeVariable('append_whole');
  const recursive = env.clone();
  if (!unify(left, cons(item, leftTail), recursive) || !unify(whole, cons(item, wholeTail), recursive)) return;
  yield* appendRelational(leftTail, right, wholeTail, recursive);
}

function scalarLexicalValue(term, env) {
  const resolved = deref(term, env);
  return resolved.type === ATOM || resolved.type === 'string' || resolved.type === 'number'
    ? resolved.name
    : null;
}

function twoLexicalInputsReady(goal, env) {
  return lexicalValue(goal.args[0], env) != null && lexicalValue(goal.args[1], env) != null;
}

function* strConcatBuiltin({ goal, env }) {
  const left = scalarLexicalValue(goal.args[0], env);
  const right = scalarLexicalValue(goal.args[1], env);
  if (left == null || right == null) return;
  const next = env.clone();
  if (unify(goal.args[2], stringTerm(left + right), next)) yield next;
}

function* containsBuiltin({ goal, env }) {
  const text = lexicalValue(goal.args[0], env);
  const needle = lexicalValue(goal.args[1], env);
  if (text != null && needle != null && text.includes(needle)) yield env;
}

function* matchesBuiltin({ goal, env }) {
  const text = lexicalValue(goal.args[0], env);
  const pattern = lexicalValue(goal.args[1], env);
  if (text != null && pattern != null && pattern.split('|').some((part) => text.includes(part))) yield env;
}

function* matchesAlternativeBuiltin({ goal, env }) {
  const alternatives = properListItems(goal.args[1], env);
  if (alternatives == null) return;
  const text = lexicalValue(goal.args[0], env);
  if (text == null) return;
  for (const alternative of alternatives) {
    const value = lexicalValue(alternative, env);
    if (value != null && text.includes(value)) {
      yield env;
      return;
    }
  }
}

function* joinBuiltin({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  const separator = scalarLexicalValue(goal.args[1], env);
  if (items == null || separator == null) return;
  const values = [];
  for (const item of items) {
    const value = scalarLexicalValue(item, env);
    if (value == null) return;
    values.push(value);
  }
  const next = env.clone();
  if (unify(goal.args[2], stringTerm(values.join(separator)), next)) yield next;
}

function* joinAtomsBuiltin({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  const separator = scalarLexicalValue(goal.args[1], env);
  const initial = scalarLexicalValue(goal.args[2], env);
  if (items == null || separator == null || initial == null) return;
  let value = initial;
  for (const item of items) {
    const text = scalarLexicalValue(item, env);
    if (text == null) return;
    value += separator + text;
  }
  const next = env.clone();
  if (unify(goal.args[3], atom(value), next)) yield next;
}

function* substringBuiltin({ goal, env }) {
  const text = scalarLexicalValue(goal.args[0], env);
  const start = integerArgument(goal.args[1], env);
  const count = integerArgument(goal.args[2], env);
  if (text == null || start == null || count == null) return;
  if (start < 0n || count < 0n || start > BigInt(Number.MAX_SAFE_INTEGER) || count > BigInt(Number.MAX_SAFE_INTEGER)) return;
  const chars = Array.from(text);
  const begin = Number(start);
  const size = Number(count);
  if (begin + size > chars.length) return;
  const next = env.clone();
  if (unify(goal.args[3], stringTerm(chars.slice(begin, begin + size).join('')), next)) yield next;
}

function* memberBuiltin({ goal, env }) {
  const spine = listSpine(goal.args[1], env);
  if (spine == null) return;
  for (const item of spine.items) {
    const next = env.clone();
    if (unify(goal.args[0], item, next)) yield next;
  }
  if (spine.tail.type === 'var') yield* memberOpenTail(goal.args[0], spine.tail, env);
}

function* memberOpenTail(item, list, env) {
  const head = nativeVariable('member_head');
  const tail = nativeVariable('member_tail');
  const first = env.clone();
  if (unify(list, cons(head, tail), first) && unify(item, head, first)) yield first;
  const rest = env.clone();
  if (unify(list, cons(head, tail), rest)) yield* memberOpenTail(item, tail, rest);
}

function* selectBuiltin({ goal, env }) {
  const spine = listSpine(goal.args[1], env);
  if (!isProperSpine(spine)) {
    yield* selectRelational(goal.args[0], goal.args[1], goal.args[2], env);
    return;
  }
  for (let index = 0; index < spine.items.length; index++) {
    const rest = [...spine.items.slice(0, index), ...spine.items.slice(index + 1)];
    const next = env.clone();
    if (unify(goal.args[0], spine.items[index], next) &&
        unify(goal.args[2], listFromItems(rest), next)) yield next;
  }
}

function* selectRelational(item, list, rest, env) {
  const tail = nativeVariable('select_tail');
  const first = env.clone();
  if (unify(list, cons(item, tail), first) && unify(rest, tail, first)) yield first;

  const head = nativeVariable('select_head');
  const listTail = nativeVariable('select_list');
  const restTail = nativeVariable('select_rest');
  const recursive = env.clone();
  if (!unify(list, cons(head, listTail), recursive) || !unify(rest, cons(head, restTail), recursive)) return;
  yield* selectRelational(item, listTail, restTail, recursive);
}

function* headBuiltin({ goal, env }) {
  const head = nativeVariable('head');
  const tail = nativeVariable('tail');
  const next = env.clone();
  if (unify(goal.args[0], cons(head, tail), next) && unify(goal.args[1], head, next)) yield next;
}

function* restBuiltin({ goal, env }) {
  const head = nativeVariable('head');
  const tail = nativeVariable('tail');
  const next = env.clone();
  if (unify(goal.args[0], cons(head, tail), next) && unify(goal.args[1], tail, next)) yield next;
}

function* lastBuiltin({ goal, env }) {
  const spine = listSpine(goal.args[0], env);
  if (isProperSpine(spine) && spine.items.length > 0) {
    const next = env.clone();
    if (unify(goal.args[1], spine.items[spine.items.length - 1], next)) yield next;
    return;
  }
  yield* lastRelational(goal.args[0], goal.args[1], env);
}

function* lastRelational(list, item, env) {
  const singleton = env.clone();
  if (unify(list, cons(item, emptyList()), singleton)) yield singleton;
  const head = nativeVariable('last_head');
  const tail = nativeVariable('last_tail');
  const recursive = env.clone();
  if (unify(list, cons(head, tail), recursive)) yield* lastRelational(tail, item, recursive);
}

function* nth0Builtin({ goal, env }) {
  yield* nthBuiltin(goal.args[0], goal.args[1], goal.args[2], env, 0n);
}

function* nth1Builtin({ goal, env }) {
  yield* nthBuiltin(goal.args[0], goal.args[1], goal.args[2], env, 1n);
}

function* nthBuiltin(indexTerm, listTerm, itemTerm, env, base) {
  const index = deref(indexTerm, env);
  const spine = listSpine(listTerm, env);
  if (!isProperSpine(spine)) return;
  if (index.type === 'var' && base === 1n) {
    if (spine.items.length > 0) throw new PrologError('instantiation_error');
    return;
  }
  if (index.type === 'var') {
    for (let position = 0; position < spine.items.length; position++) {
      const next = env.clone();
      if (unify(indexTerm, numberTerm((BigInt(position) + base).toString()), next) &&
          unify(itemTerm, spine.items[position], next)) yield next;
    }
    return;
  }
  if (index.type !== 'number' || !isDecimalInteger(index.name)) return;
  const position = BigInt(index.name) - base;
  if (position < 0n || position >= BigInt(spine.items.length)) return;
  const next = env.clone();
  if (unify(itemTerm, spine.items[Number(position)], next)) yield next;
}

function* setNth0Builtin({ goal, env }) {
  const index = integerArgument(goal.args[0], env);
  if (index == null || index < 0n || index > BigInt(Number.MAX_SAFE_INTEGER)) return;
  const spine = listSpine(goal.args[1], env);
  if (!isProperSpine(spine) || index >= BigInt(spine.items.length)) return;
  const items = spine.items.slice();
  items[Number(index)] = goal.args[2];
  const next = env.clone();
  if (unify(goal.args[3], listFromItems(items), next)) yield next;
}

function* takeBuiltin({ goal, env }) {
  const count = integerArgument(goal.args[0], env);
  if (count == null || count < 0n || count > BigInt(Number.MAX_SAFE_INTEGER)) return;
  if (count === 0n) {
    const next = env.clone();
    if (unify(goal.args[2], emptyList(), next)) yield next;
    return;
  }
  const spine = listSpine(goal.args[1], env);
  if (spine == null || count > BigInt(spine.items.length)) return;
  const next = env.clone();
  if (unify(goal.args[2], listFromItems(spine.items, 0, Number(count)), next)) yield next;
}

function* dropBuiltin({ goal, env }) {
  const count = integerArgument(goal.args[0], env);
  if (count == null || count < 0n || count > BigInt(Number.MAX_SAFE_INTEGER)) return;
  if (count === 0n) {
    const next = env.clone();
    if (unify(goal.args[2], goal.args[1], next)) yield next;
    return;
  }
  const spine = listSpine(goal.args[1], env);
  if (spine == null || count > BigInt(spine.items.length)) return;
  const suffix = listFromItems(spine.items, Number(count), spine.items.length, spine.tail);
  const next = env.clone();
  if (unify(goal.args[2], suffix, next)) yield next;
}

function* sliceBuiltin({ goal, env }) {
  const start = integerArgument(goal.args[0], env);
  const count = integerArgument(goal.args[1], env);
  if (start == null || count == null || start < 0n || count < 0n ||
      start > BigInt(Number.MAX_SAFE_INTEGER) || count > BigInt(Number.MAX_SAFE_INTEGER)) return;
  const spine = listSpine(goal.args[2], env);
  if (spine == null) return;
  const begin = Number(start);
  const end = begin + Number(count);
  if (end > spine.items.length) return;
  const next = env.clone();
  if (unify(goal.args[3], listFromItems(spine.items, begin, end), next)) yield next;
}

function* reverseBuiltin({ goal, env }) {
  const left = properListItems(goal.args[0], env);
  if (left == null) return;
  const next = env.clone();
  if (unify(goal.args[1], listFromItems([...left].reverse()), next)) yield next;
}

function* reverseAccBuiltin({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  if (items == null) return;
  const result = listFromItems([...items].reverse(), 0, items.length, goal.args[1]);
  const next = env.clone();
  if (unify(goal.args[2], result, next)) yield next;
}

function* lengthBuiltin({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  if (items == null) {
    const list = deref(goal.args[0], env);
    const size = deref(goal.args[1], env);
    if (list.type !== 'var' || size.type !== 'number' || !isDecimalInteger(size.name)) return;
    const count = BigInt(size.name);
    if (count < 0n || count > 1000000n) return;
    const stem = String(list.name).replace(/[^A-Za-z0-9_]/g, '_');
    const generated = Array.from({ length: Number(count) }, (_, index) => variable(`_length_${stem}_${index}`));
    const next = env.clone();
    if (unify(goal.args[0], listFromItems(generated), next)) yield next;
    return;
  }
  const next = env.clone();
  if (unify(goal.args[1], numberTerm(items.length), next)) yield next;
}

function addArithmeticValues(left, right) {
  if (left.integer && right.integer) return { integer: true, value: left.value + right.value };
  return { integer: false, value: Number(left.value) + Number(right.value) };
}

function* sumListBuiltin({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  if (items == null) return;
  let total = { integer: true, value: 0n };
  for (const item of items) total = addArithmeticValues(total, evaluateArithmetic(item, env));
  const next = env.clone();
  if (unify(goal.args[1], arithmeticValueTerm(total), next)) yield next;
}

function* minListBuiltin({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  if (items == null || items.length === 0) return;
  yield* extremumList(items.slice(1), items[0], goal.args[1], env, -1);
}

function* minListAccBuiltin({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  if (items == null) return;
  yield* extremumList(items, goal.args[1], goal.args[2], env, -1);
}

function* maxListBuiltin({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  if (items == null || items.length === 0) return;
  yield* extremumList(items.slice(1), items[0], goal.args[1], env, 1);
}

function* maxListAccBuiltin({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  if (items == null) return;
  yield* extremumList(items, goal.args[1], goal.args[2], env, 1);
}

function* extremumList(items, initial, output, env, direction) {
  let best = copyResolved(initial, env);
  for (const item of items) {
    const candidate = copyResolved(item, env);
    if (compareTerms(candidate, best) * direction > 0) best = candidate;
  }
  const next = env.clone();
  if (unify(output, best, next)) yield next;
}

function* notMemberBuiltin({ goal, env }) {
  const items = properListItems(goal.args[1], env);
  if (items == null) {
    yield env;
    return;
  }
  for (const item of items) {
    const test = env.clone();
    if (unify(goal.args[0], item, test)) return;
  }
  yield env;
}

function* listToSetBuiltin({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  if (items == null) return;
  const unique = [];
  for (const item of items) {
    if (!unique.some((seen) => exactIdentity(item, seen, env))) unique.push(copyResolved(item, env));
  }
  const next = env.clone();
  if (unify(goal.args[1], listFromItems(unique), next)) yield next;
}

function sortedUnique(items, env) {
  const sorted = items.map((item) => copyResolved(item, env)).sort(compareTerms);
  const unique = [];
  for (const item of sorted) {
    if (unique.length === 0 || compareTerms(unique[unique.length - 1], item) !== 0) unique.push(item);
  }
  return unique;
}

function* sortBuiltin({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  if (items == null) return;
  const next = env.clone();
  if (unify(goal.args[1], listFromItems(sortedUnique(items, env)), next)) yield next;
}

function insertUniqueItems(item, items, env) {
  const resolvedItem = copyResolved(item, env);
  const output = [];
  for (let index = 0; index < items.length; index++) {
    const current = copyResolved(items[index], env);
    const cmp = compareTerms(resolvedItem, current);
    if (cmp === 0) return [...output, ...items.slice(index).map((entry) => copyResolved(entry, env))];
    if (cmp < 0) return [...output, resolvedItem, ...items.slice(index).map((entry) => copyResolved(entry, env))];
    output.push(current);
  }
  output.push(resolvedItem);
  return output;
}

function* sortAccBuiltin({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  const acc = properListItems(goal.args[1], env);
  if (items == null || acc == null) return;
  let result = acc.map((item) => copyResolved(item, env));
  for (const item of items) result = insertUniqueItems(item, result, new Env());
  const next = env.clone();
  if (unify(goal.args[2], listFromItems(result), next)) yield next;
}

function* insertUniqueBuiltin({ goal, env }) {
  const items = properListItems(goal.args[1], env);
  if (items == null) return;
  const next = env.clone();
  if (unify(goal.args[2], listFromItems(insertUniqueItems(goal.args[0], items, env)), next)) yield next;
}

function* countallBuiltin({ solver, goal, env }) {
  const collector = solver.cloneForInnerGoal(10000000);
  let count = 0;
  try {
    for (const _ of collector.solve([goal.args[0]], env.clone(), 0)) count++;
  } finally {
    solver.absorbStatsFrom(collector);
  }
  const next = env.clone();
  if (unify(goal.args[1], numberTerm(count), next)) yield next;
}

function* sumallBuiltin({ solver, goal, env }) {
  const collector = solver.cloneForInnerGoal(10000000);
  let total = { integer: true, value: 0n };
  try {
    for (const answer of collector.solve([goal.args[1]], env.clone(), 0)) {
      total = addArithmeticValues(total, evaluateArithmetic(goal.args[0], answer));
    }
  } finally {
    solver.absorbStatsFrom(collector);
  }
  const next = env.clone();
  if (unify(goal.args[2], arithmeticValueTerm(total), next)) yield next;
}

function aggregateBuiltin(direction) {
  return function* ({ solver, goal, env }) {
    const collector = solver.cloneForInnerGoal(10000000);
    let bestKey = null;
    let bestValue = null;
    try {
      for (const answer of collector.solve([goal.args[2]], env.clone(), 0)) {
        const key = copyResolved(goal.args[0], answer);
        if (bestKey == null || compareTerms(key, bestKey) * direction > 0) {
          bestKey = key;
          bestValue = copyResolved(goal.args[1], answer);
        }
      }
    } finally {
      solver.absorbStatsFrom(collector);
    }
    if (bestKey == null) return;
    const next = env.clone();
    if (unify(goal.args[3], bestKey, next) && unify(goal.args[4], bestValue, next)) yield next;
  };
}

function pairItems(list, env) {
  const items = properListItems(list, env);
  if (items == null) return null;
  const pairs = [];
  for (const item of items) {
    const resolved = deref(item, env);
    if (resolved.type !== COMPOUND || resolved.name !== 'pair' || resolved.arity !== 2) return null;
    pairs.push([copyResolved(resolved.args[0], env), copyResolved(resolved.args[1], env)]);
  }
  return pairs;
}

function aggregatePairsBuiltin(direction) {
  return function* ({ goal, env }) {
    const pairs = pairItems(goal.args[0], env);
    if (pairs == null || pairs.length === 0) return;
    let [bestKey, bestValue] = pairs[0];
    for (let index = 1; index < pairs.length; index++) {
      if (compareTerms(pairs[index][0], bestKey) * direction > 0) [bestKey, bestValue] = pairs[index];
    }
    const next = env.clone();
    if (unify(goal.args[1], bestKey, next) && unify(goal.args[2], bestValue, next)) yield next;
  };
}

function aggregateAccBuiltin(direction) {
  return function* ({ goal, env }) {
    const pairs = pairItems(goal.args[0], env);
    if (pairs == null) return;
    let bestKey = copyResolved(goal.args[1], env);
    let bestValue = copyResolved(goal.args[2], env);
    for (const pair of pairs) {
      if (compareTerms(pair[0], bestKey) * direction > 0) [bestKey, bestValue] = pair;
    }
    const next = env.clone();
    if (unify(goal.args[3], bestKey, next) && unify(goal.args[4], bestValue, next)) yield next;
  };
}

function numericChoiceBuiltin(direction) {
  return function* ({ goal, env }) {
    const left = evaluateArithmetic(goal.args[0], env);
    const right = evaluateArithmetic(goal.args[1], env);
    const cmp = compareArithmeticValues(left, right);
    const chooseLeft = direction < 0 ? cmp <= 0 : cmp >= 0;
    const next = env.clone();
    if (unify(goal.args[2], chooseLeft ? goal.args[0] : goal.args[1], next)) yield next;
  };
}

function* betweenRangeBuiltin({ goal, env }) {
  const low = integerArgument(goal.args[0], env);
  const high = integerArgument(goal.args[1], env);
  if (low == null || high == null || low > high) return;
  yield* emitRange(low, high, goal.args[2], env);
}

function* emitRange(low, high, output, env) {
  if (low === high) {
    const next = env.clone();
    if (unify(output, numberTerm(low.toString()), next)) yield next;
    return;
  }
  const mid = low + ((high - low) / 2n);
  yield* emitRange(low, mid, output, env);
  yield* emitRange(mid + 1n, high, output, env);
}

function conjunctionMembers(context, env) {
  const members = [];
  const pending = [context];
  while (pending.length) {
    const current = deref(pending.pop(), env);
    if (current.type === COMPOUND && current.name === ',' && current.arity === 2) {
      pending.push(current.args[1], current.args[0]);
    } else if (current.type !== 'var') {
      members.push(current);
    }
  }
  return members;
}

function* holdsBuiltin({ goal, env }) {
  for (const member of conjunctionMembers(goal.args[0], env)) {
    const next = env.clone();
    if (unify(goal.args[1], member, next)) yield next;
  }
}

function* holdsPartsBuiltin({ goal, env }) {
  for (const member of conjunctionMembers(goal.args[0], env)) {
    if (member.type !== ATOM && member.type !== COMPOUND) continue;
    const name = atom(member.name);
    const args = member.type === COMPOUND ? listFromItems(member.args) : emptyList();
    const next = env.clone();
    if (unify(goal.args[1], name, next) && unify(goal.args[2], args, next)) yield next;
  }
}

function integerArgument(term, env) {
  const resolved = deref(term, env);
  if (resolved.type !== 'number' || !isDecimalInteger(resolved.name)) return null;
  return BigInt(resolved.name);
}

export function createLibraryRegistry() {
  const registry = new BuiltinRegistry();
  registry.standardLibrary = true;
  for (const mod of [
    coreBuiltins,
    metaCallBuiltins,
    arithmeticBuiltins,
    stringBuiltins,
    standardBuiltins,
    isoBuiltins,
  ]) {
    mod.register(registry);
  }
  return registry;
}

let libraryRegistry = null;

export function getLibraryRegistry() {
  if (libraryRegistry == null) libraryRegistry = createLibraryRegistry();
  return libraryRegistry;
}
