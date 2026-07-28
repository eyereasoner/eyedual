// List builtins for proper lists, selection, membership, sorting, indexing, slicing, and summaries.
// Several predicates support both checking and generation, so the argument modes are handled explicitly.
import {
  compareTerms,
  copyResolved,
  deref,
  isDecimalInteger,
  isCons,
  lexicalValue,
  listFromItems,
  numberTerm,
  numberTextFromDouble,
  parseFiniteNumber,
  properListItems,
  unify,
} from '../term.js';

export const listBuiltins = {
  register(registry) {
    registry.add('append', 3, append, portable());
    registry.add('nth0', 3, nth0, portable());
    registry.add('set_nth0', 4, setNth0, portable({ deterministic: true }));
    registry.add('head', 2, head, portable({ deterministic: true, fallbackWhenNotReady: true, ready: firstConsReady }));
    registry.add('rest', 2, rest, portable({ deterministic: true, fallbackWhenNotReady: true, ready: firstConsReady }));
    registry.add('last', 2, last, portable({ deterministic: true, fallbackWhenNotReady: true, ready: firstProperListReady }));
    registry.add('take', 3, take, portable({ deterministic: true, fallbackWhenNotReady: true, ready: countAndListReady }));
    registry.add('drop', 3, drop, portable({ deterministic: true, fallbackWhenNotReady: true, ready: countAndListReady }));
    registry.add('slice', 4, slice, portable({ deterministic: true, fallbackWhenNotReady: true, ready: sliceReady }));
    registry.add('member', 2, member, portable());
    registry.add('select', 3, select, portable());
    registry.add('not_member', 2, notMember, portable({ deterministic: true }));
    registry.add('reverse', 2, reverse, portable({ deterministic: true }));
    registry.add('length', 2, lengthBuiltin, portable({ deterministic: true }));
    registry.add('sum_list', 2, sumList, portable({ deterministic: true, fallbackWhenNotReady: true, ready: firstProperListReady }));
    registry.add('min_list', 2, minList, portable({ deterministic: true, fallbackWhenNotReady: true, ready: firstProperListReady }));
    registry.add('max_list', 2, maxList, portable({ deterministic: true, fallbackWhenNotReady: true, ready: firstProperListReady }));
    registry.add('list_to_set', 2, listToSet, portable({ deterministic: true, fallbackWhenNotReady: true, ready: firstProperListReady }));
    registry.add('sort', 2, sortBuiltin, portable({ deterministic: true }));
  }
};

function portable(options = {}) {
  return { ...options, portableEquivalent: true };
}

function firstConsReady(goal, env) {
  return isCons(deref(goal.args[0], env));
}

function firstProperListReady(goal, env) {
  return properListItems(goal.args[0], env) !== null;
}

function countAndListReady(goal, env) {
  return safeIndex(goal.args[0], env) !== null && properListItems(goal.args[1], env) !== null;
}

function sliceReady(goal, env) {
  return safeIndex(goal.args[0], env) !== null && safeIndex(goal.args[1], env) !== null && properListItems(goal.args[2], env) !== null;
}

function listFromItemsExcept(items, skip) {
  const copy = new Array(items.length - 1);
  for (let i = 0, j = 0; i < items.length; i++) if (i !== skip) copy[j++] = items[i];
  return listFromItems(copy);
}

function* append({ goal, env }) {
  let items = properListItems(goal.args[0], env);
  if (items) {
    const result = listFromItems(items, 0, items.length, deref(goal.args[1], env));
    const next = env.clone();
    if (unify(goal.args[2], result, next)) yield next;
    return;
  }
  items = properListItems(goal.args[2], env);
  if (!items) return;
  for (let split = 0; split <= items.length; split++) {
    const prefix = listFromItems(items, 0, split);
    const suffix = listFromItems(items, split, items.length);
    const next = env.clone();
    if (unify(goal.args[0], prefix, next) && unify(goal.args[1], suffix, next)) yield next;
  }
}

function* nth0({ goal, env }) {
  const items = properListItems(goal.args[1], env);
  if (!items) return;
  const indexText = lexicalValue(goal.args[0], env);
  if (/^-?\d+$/.test(indexText ?? '')) {
    const index = Number(indexText);
    if (Number.isSafeInteger(index) && index >= 0 && index < items.length) {
      const next = env.clone();
      if (unify(goal.args[2], items[index], next)) yield next;
    }
    return;
  }
  if (deref(goal.args[0], env).type !== 'var') return;
  for (let i = 0; i < items.length; i++) {
    const next = env.clone();
    if (unify(goal.args[0], numberTerm(i), next) && unify(goal.args[2], items[i], next)) yield next;
  }
}

function* setNth0({ goal, env }) {
  const index = safeIndex(goal.args[0], env);
  if (index == null) return;
  const items = properListItems(goal.args[1], env);
  if (!items || index >= items.length) return;
  const out = items.slice();
  out[index] = goal.args[2];
  const next = env.clone();
  if (unify(goal.args[3], listFromItems(out), next)) yield next;
}

function* head({ goal, env }) {
  const list = deref(goal.args[0], env);
  if (!isCons(list)) return;
  const next = env.clone();
  if (unify(goal.args[1], list.args[0], next)) yield next;
}

function* rest({ goal, env }) {
  const list = deref(goal.args[0], env);
  if (!isCons(list)) return;
  const next = env.clone();
  if (unify(goal.args[1], list.args[1], next)) yield next;
}

function* last({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  if (!items || items.length === 0) return;
  const next = env.clone();
  if (unify(goal.args[1], items[items.length - 1], next)) yield next;
}

function* take({ goal, env }) {
  const count = safeIndex(goal.args[0], env);
  if (count == null) return;
  const items = properListItems(goal.args[1], env);
  if (!items || count > items.length) return;
  const next = env.clone();
  if (unify(goal.args[2], listFromItems(items, 0, count), next)) yield next;
}

function* drop({ goal, env }) {
  const count = safeIndex(goal.args[0], env);
  if (count == null) return;
  const items = properListItems(goal.args[1], env);
  if (!items || count > items.length) return;
  const next = env.clone();
  if (unify(goal.args[2], listFromItems(items, count, items.length), next)) yield next;
}

function* slice({ goal, env }) {
  const start = safeIndex(goal.args[0], env);
  const count = safeIndex(goal.args[1], env);
  if (start == null || count == null) return;
  const items = properListItems(goal.args[2], env);
  if (!items || start + count > items.length) return;
  const next = env.clone();
  if (unify(goal.args[3], listFromItems(items, start, start + count), next)) yield next;
}

function* member({ goal, env }) {
  const items = properListItems(goal.args[1], env);
  if (!items) return;
  for (const item of items) {
    const next = env.clone();
    if (unify(goal.args[0], item, next)) yield next;
  }
}

function* select({ goal, env }) {
  const items = properListItems(goal.args[1], env);
  if (!items) return;
  for (let i = 0; i < items.length; i++) {
    const next = env.clone();
    if (unify(goal.args[0], items[i], next) && unify(goal.args[2], listFromItemsExcept(items, i), next)) yield next;
  }
}

function* notMember({ goal, env }) {
  const items = properListItems(goal.args[1], env);
  if (!items) return;
  const value = deref(goal.args[0], env);
  if (value.type === 'number' || value.type === 'atom' || value.type === 'string') {
    for (const item of items) {
      const resolved = deref(item, env);
      if (resolved.type === value.type && resolved.name === value.name) return;
    }
    yield env;
    return;
  }
  for (const item of items) {
    const attempt = env.clone();
    if (unify(goal.args[0], item, attempt)) return;
  }
  yield env;
}

function* reverse({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  if (!items) return;
  const next = env.clone();
  if (unify(goal.args[1], listFromItems([...items].reverse()), next)) yield next;
}

function* lengthBuiltin({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  if (!items) return;
  const next = env.clone();
  if (unify(goal.args[1], numberTerm(items.length), next)) yield next;
}

function* sumList({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  if (!items) return;
  let intSum = 0n;
  let floatMode = false;
  let floatSum = 0;
  for (const item of items) {
    const text = lexicalValue(item, env);
    if (text == null) return;
    if (!floatMode && isDecimalInteger(text)) intSum += BigInt(text);
    else {
      const value = parseFiniteNumber(text);
      if (value == null) return;
      if (!floatMode) { floatSum = Number(intSum); floatMode = true; }
      floatSum += value;
    }
  }
  const out = floatMode ? numberTextFromDouble(floatSum) : intSum.toString();
  const next = env.clone();
  if (unify(goal.args[1], numberTerm(out), next)) yield next;
}

function* minList({ goal, env }) {
  yield* minMaxList(goal, env, true);
}

function* maxList({ goal, env }) {
  yield* minMaxList(goal, env, false);
}

function* minMaxList(goal, env, wantMin) {
  const items = properListItems(goal.args[0], env);
  if (!items || items.length === 0) return;
  let best = copyResolved(items[0], env);
  for (let i = 1; i < items.length; i++) {
    const item = copyResolved(items[i], env);
    const cmp = compareTerms(item, best);
    if ((wantMin && cmp < 0) || (!wantMin && cmp > 0)) best = item;
  }
  const next = env.clone();
  if (unify(goal.args[1], best, next)) yield next;
}

function* listToSet({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  if (!items) return;
  const unique = [];
  for (const item of items.map((entry) => copyResolved(entry, env))) {
    if (!unique.some((seen) => compareTerms(seen, item) === 0)) unique.push(item);
  }
  const next = env.clone();
  if (unify(goal.args[1], listFromItems(unique), next)) yield next;
}

function* sortBuiltin({ goal, env }) {
  const items = properListItems(goal.args[0], env);
  if (!items) return;
  const sorted = items.map((item) => copyResolved(item, env)).sort(compareTerms);
  const unique = [];
  for (const item of sorted) if (unique.length === 0 || compareTerms(unique[unique.length - 1], item) !== 0) unique.push(item);
  const next = env.clone();
  if (unify(goal.args[1], listFromItems(unique), next)) yield next;
}

function safeIndex(term, env) {
  const text = lexicalValue(term, env);
  if (!/^-?\d+$/.test(text ?? '')) return null;
  const index = Number(text);
  return Number.isSafeInteger(index) && index >= 0 ? index : null;
}
