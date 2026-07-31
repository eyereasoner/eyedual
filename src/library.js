// Eyepl standard library: host primitives, portable ISO clauses,
// and the small profile-guided accelerator set.
import {
  ATOM,
  COMPOUND,
  atom,
  compareIntegerText,
  compareTerms,
  compound,
  copyResolved,
  deref,
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
import { BuiltinRegistry, PrologError, isoBuiltins } from './iso.js';

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
    registry.add('between', 3, between, { portableEquivalent: true });
    registry.add('smallest_divisor_from', 3, smallestDivisorFrom, {
      deterministic: true,
      portableEquivalent: true,
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
    registry.add('maplist', 3, maplistTwoLists);
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


// Selected accelerators for portable relations whose ISO definitions are
// measurably expensive in representative workloads.

export const portableAccelerators = {
  register(registry) {
    registry.add('countall', 2, countall, { portableEquivalent: true });
    registry.add('length', 2, length, {
      deterministic: true,
      portableEquivalent: true,
    });
    registry.add('member', 2, member, { portableEquivalent: true });
    registry.add('select', 3, select, { portableEquivalent: true });
    registry.add('reverse', 2, reverse, {
      deterministic: true,
      portableEquivalent: true,
    });
    registry.add('sort', 2, sort, {
      deterministic: true,
      portableEquivalent: true,
    });
    registry.add('contains', 2, contains, {
      deterministic: true,
      fallbackWhenNotReady: true,
      ready: twoLexicalInputsReady,
      portableEquivalent: true,
    });
    registry.add('matches', 2, matches, {
      deterministic: true,
      fallbackWhenNotReady: true,
      ready: twoLexicalInputsReady,
      portableEquivalent: true,
    });
  }
};

function* countall({ solver, goal, env }) {
  const collector = solver.cloneForInnerGoal(10000000);
  let count = 0;
  for (const _ of collector.solve([goal.args[0]], env.clone(), 0)) count++;
  solver.absorbStatsFrom(collector);
  const next = env.clone();
  if (unify(goal.args[1], numberTerm(count), next)) yield next;
}

let generatedListVariable = 0;

function* length({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  if (items == null) {
    const list = deref(goal.args[0], env);
    const size = deref(goal.args[1], env);
    if (list.type !== 'var' || size.type !== 'number' || !isDecimalInteger(size.name)) return;
    const count = BigInt(size.name);
    if (count < 0n || count > 1000000n) return;
    const id = ++generatedListVariable;
    const generated = Array.from({ length: Number(count) }, (_, index) =>
      variable(`_length_${id}_${index}`));
    const next = env.clone();
    if (unify(goal.args[0], listFromItems(generated), next)) yield next;
    return;
  }
  const next = env.clone();
  if (unify(goal.args[1], numberTerm(items.length), next)) yield next;
}

function* member({ goal, env }) {
  const items = properListItems(goal.args[1], env);
  if (items == null) return;
  for (const item of items) {
    const next = env.clone();
    if (unify(goal.args[0], item, next)) yield next;
  }
}

function* select({ goal, env }) {
  const items = properListItems(goal.args[1], env);
  if (items == null) return;
  for (let i = 0; i < items.length; i++) {
    const rest = [...items.slice(0, i), ...items.slice(i + 1)];
    const next = env.clone();
    if (unify(goal.args[0], items[i], next) &&
        unify(goal.args[2], listFromItems(rest), next)) yield next;
  }
}

function* reverse({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  if (items == null) return;
  const next = env.clone();
  if (unify(goal.args[1], listFromItems([...items].reverse()), next)) yield next;
}

function* sort({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  if (items == null) return;
  const sorted = items.map((item) => copyResolved(item, env)).sort(compareTerms);
  const unique = [];
  for (const item of sorted) {
    if (unique.length === 0 ||
        compareTerms(unique[unique.length - 1], item) !== 0) unique.push(item);
  }
  const next = env.clone();
  if (unify(goal.args[1], listFromItems(unique), next)) yield next;
}

function twoLexicalInputsReady(goal, env) {
  return lexicalValue(goal.args[0], env) != null &&
    lexicalValue(goal.args[1], env) != null;
}

function* contains({ goal, env }) {
  const text = lexicalValue(goal.args[0], env);
  const needle = lexicalValue(goal.args[1], env);
  if (text.includes(needle)) yield env;
}

function* matches({ goal, env }) {
  const text = lexicalValue(goal.args[0], env);
  const pattern = lexicalValue(goal.args[1], env);
  if (pattern.split('|').some((part) => text.includes(part))) yield env;
}


// Relations that need no host primitive are ordinary ISO-style Prolog clauses.
// They live in a standalone browser-safe module so both Node and the playground
// consume the same source.
import { portableLibrarySource } from './portable-library.js';
export { portableLibrarySource } from './portable-library.js';

export function createLibraryRegistry() {
  const registry = new BuiltinRegistry();
  registry.portableSource = portableLibrarySource;
  for (const mod of [
    coreBuiltins,
    metaCallBuiltins,
    arithmeticBuiltins,
    stringBuiltins,
    portableAccelerators,
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
