// String builtins.
// They mostly project from already-ground terms to avoid guessing string domains.
import {
  atom,
  compound,
  deref,
  isDecimalInteger,
  lexicalValue,
  listFromItems,
  numberTerm,
  parseFiniteNumber,
  properListItems,
  stringTerm,
  termToString,
  unify,
} from '../term.js';

export const stringBuiltins = {
  register(registry) {
    registry.add('str_concat', 3, concat, { deterministic: true });
    for (const name of ['contains', 'matches']) registry.add(name, 2, contains(name), { deterministic: true });
    registry.add('matches', 3, matchCaptures, { deterministic: true });
    registry.add('split', 3, split, { deterministic: true, fallbackWhenNotReady: true, ready: firstTwoLexicalReady });
    registry.add('join', 3, join, { deterministic: true, fallbackWhenNotReady: true, ready: listAndSecondLexicalReady });
    registry.add('substring', 4, substring, { deterministic: true, fallbackWhenNotReady: true, ready: substringReady });
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

function listAndSecondLexicalReady(goal, env) {
  return properListItems(goal.args[0], env) !== null && lexicalValue(goal.args[1], env) !== null;
}

function substringReady(goal, env) {
  return lexicalValue(goal.args[0], env) !== null && safeIndex(goal.args[1], env) !== null && safeIndex(goal.args[2], env) !== null;
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

function* concat({ goal, env }) {
  const left = lexicalValue(goal.args[0], env);
  const right = lexicalValue(goal.args[1], env);
  if (left == null || right == null) return;
  const next = env.clone();
  if (unify(goal.args[2], stringTerm(left + right), next)) yield next;
}

function contains(name) {
  return function* ({ goal, env }) {
    const haystack = lexicalValue(goal.args[0], env);
    const needle = lexicalValue(goal.args[1], env);
    if (haystack == null || needle == null) return;
    const has = haystack.includes(needle);
    const matches = simpleAlternationMatch(haystack, needle);
    const pass = (name === 'contains' && has) || (name === 'matches' && matches);
    if (pass) yield env;
  };
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

function* join({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  const separator = lexicalValue(goal.args[1], env);
  if (!items || separator == null) return;
  const strings = [];
  for (const item of items) {
    const value = lexicalValue(item, env);
    if (value == null) return;
    strings.push(value);
  }
  const next = env.clone();
  if (unify(goal.args[2], stringTerm(strings.join(separator)), next)) yield next;
}

function* substring({ goal, env }) {
  const text = lexicalValue(goal.args[0], env);
  const start = safeIndex(goal.args[1], env);
  const count = safeIndex(goal.args[2], env);
  if (text == null || start == null || count == null || start + count > text.length) return;
  const next = env.clone();
  if (unify(goal.args[3], stringTerm(text.slice(start, start + count)), next)) yield next;
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

function simpleAlternationMatch(haystack, pattern) {
  return pattern.split('|').some((part) => part === '' || haystack.includes(part));
}

function safeIndex(term, env) {
  const text = lexicalValue(term, env);
  if (!/^-?\d+$/.test(text ?? '')) return null;
  const index = Number(text);
  return Number.isSafeInteger(index) && index >= 0 ? index : null;
}

function numericText(text) {
  return isDecimalInteger(text) || parseFiniteNumber(text) != null;
}
