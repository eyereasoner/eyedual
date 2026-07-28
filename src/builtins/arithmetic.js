// Numeric builtins for integer-preserving arithmetic, floating point functions, comparisons, and ranges.
// The code keeps BigInt paths where possible so large Eyepl integers remain exact.
import { compareIntegerText, deref, isDecimalInteger, lexicalValue, numberTerm, numberTextFromDouble, parseFiniteNumber, unify } from '../term.js';

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
