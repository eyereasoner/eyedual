// Term model, environments, unification, readback, and ordering helpers.
// This file is intentionally dependency-free because nearly every other module imports it.
export const VAR = 'var';
export const ATOM = 'atom';
export const STRING = 'string';
export const NUMBER = 'number';
export const COMPOUND = 'compound';
const EMPTY_ARGS = Object.freeze([]);
let variableOrder = 0;
const variableOrders = new Map();

export class Term {
  constructor(type, name, args = []) {
    this.type = type;
    this.name = String(name ?? '');
    this.args = args;
  }
  get arity() {
    return this.args.length;
  }
}

export const variable = (name) => {
  const term = new Term(VAR, name, EMPTY_ARGS);
  if (!variableOrders.has(term.name)) variableOrders.set(term.name, ++variableOrder);
  term.order = variableOrders.get(term.name);
  return term;
};
export const atom = (name) => new Term(ATOM, name, EMPTY_ARGS);
export const stringTerm = (value) => new Term(STRING, value, EMPTY_ARGS);
export const numberTerm = (value) => new Term(NUMBER, value, EMPTY_ARGS);
export const compound = (name, args = []) => args.length === 0 ? atom(name) : new Term(COMPOUND, name, args);
export const emptyList = () => atom('[]');
export const cons = (head, tail) => compound('.', [head, tail]);

export class Env {
  constructor(bindings) {
    this._state = { bindings: bindings ? new Map(bindings) : new Map(), parent: null, depth: 0, cache: null };
  }
  clone() {
    // Most speculative environments are either rejected without a binding or
    // only compare ground terms. Persistent layers make cloning constant-time
    // and keep later writes to either branch isolated.
    const clone = Object.create(Env.prototype);
    clone._state = this._state;
    return clone;
  }
  has(name) {
    return this.get(name) !== undefined;
  }
  get(name) {
    const root = this._state;
    if (root.cache?.has(name)) return root.cache.get(name);
    for (let state = root; state != null; state = state.parent) {
      if (state.bindings.has(name)) {
        const value = state.bindings.get(name);
        if (root.depth >= 4) (root.cache ??= new Map()).set(name, value);
        return value;
      }
    }
    return undefined;
  }
  bind(name, term) {
    if (this._state.depth >= 32) {
      const flattened = new Map();
      for (let state = this._state; state != null; state = state.parent) {
        for (const [key, value] of state.bindings) {
          if (!flattened.has(key)) flattened.set(key, value);
        }
      }
      flattened.set(name, term);
      this._state = { bindings: flattened, parent: null, depth: 0, cache: null };
      return;
    }
    this._state = {
      bindings: new Map([[name, term]]),
      parent: this._state,
      depth: this._state.depth + 1,
      cache: null,
    };
  }
}

export function deref(term, env) {
  // Follow variable bindings until a non-variable term is reached. The seen set
  // protects readback from accidental cycles in partially constructed terms.
  let current = term;
  const seen = new Set();
  while (current?.type === VAR) {
    if (seen.has(current.name)) break;
    seen.add(current.name);
    const next = env?.get(current.name);
    if (next === undefined) break;
    current = next;
  }
  return current;
}

export function isScalar(term) {
  return term && (term.type === ATOM || term.type === STRING || term.type === NUMBER);
}

export function isEmptyList(term) {
  return term?.type === ATOM && term.name === '[]';
}

export function isCons(term) {
  return term?.type === COMPOUND && term.name === '.' && term.arity === 2;
}

export function isConjunction(term) {
  return term?.type === COMPOUND && term.name === ',' && term.arity === 2;
}

function occurs(variableName, term, env) {
  // Walk bindings and compound arguments iteratively so the occurs check also
  // remains safe for very deep terms. The visited sets make this defensive
  // against cycles introduced through the public Env API.
  if (isScalar(term)) return false;
  const stack = [term];
  const seenVariables = new Set();
  const seenTerms = new Set();

  while (stack.length) {
    const current = stack.pop();
    if (current?.type === VAR) {
      if (current.name === variableName) return true;
      if (seenVariables.has(current.name)) continue;
      seenVariables.add(current.name);
      const binding = env?.get(current.name);
      if (binding !== undefined) stack.push(binding);
      continue;
    }
    if (current?.type !== COMPOUND || seenTerms.has(current)) continue;
    seenTerms.add(current);
    for (let i = 0; i < current.arity; i++) stack.push(current.args[i]);
  }

  return false;
}

export function unify(left, right, env) {
  // Iterative unification avoids deep JavaScript recursion on long lists or
  // deeply nested compounds. The occurs check gives Eyepl finite-tree
  // unification: a variable cannot be bound to a term containing itself.
  // Bindings are written into the supplied Env.
  const stack = [[left, right]];
  while (stack.length) {
    let [a, b] = stack.pop();
    a = deref(a, env);
    b = deref(b, env);

    if (a.type === VAR && b.type === VAR && a.name === b.name) continue;
    if (a.type === VAR && b.type === VAR) {
      // Both variables are already dereferenced and unbound, so linking them
      // cannot create a cycle and needs no occurs-check traversal.
      env.bind(a.name, b);
      continue;
    }
    if (a.type === VAR) {
      if (occurs(a.name, b, env)) return false;
      env.bind(a.name, b);
      continue;
    }
    if (b.type === VAR) {
      if (occurs(b.name, a, env)) return false;
      env.bind(b.name, a);
      continue;
    }

    if (a.type !== b.type) {
      return false;
    }

    if (isScalar(a)) {
      if (a.name !== b.name) return false;
      continue;
    }

    if (a.type === COMPOUND) {
      if (a.name !== b.name || a.arity !== b.arity) return false;
      for (let i = a.arity - 1; i >= 0; i--) stack.push([a.args[i], b.args[i]]);
      continue;
    }

    return false;
  }
  return true;
}

export function cloneTerm(term) {
  if (term.type === COMPOUND && term.arity === 0) return atom(term.name);
  return new Term(term.type, term.name, term.args.map(cloneTerm));
}

export function freshTerm(term, suffix) {
  if (term.type === VAR) return variable(`${term.name}#${suffix}`);
  if (term.type === COMPOUND && term.arity === 0) return atom(term.name);
  return new Term(term.type, term.name, term.args.map((arg) => freshTerm(arg, suffix)));
}

export function copyResolved(term, env) {
  const resolved = deref(term, env);
  if (resolved.type === VAR) return variable(resolved.name);
  if (resolved.type === COMPOUND && resolved.arity === 0) return atom(resolved.name);
  return new Term(resolved.type, resolved.name, resolved.args.map((arg) => copyResolved(arg, env)));
}

export function termIsGround(term, env = new Env()) {
  const pending = [term];
  const seen = new Set();
  while (pending.length > 0) {
    const resolved = deref(pending.pop(), env);
    if (resolved.type === VAR) return false;
    if (seen.has(resolved)) continue;
    seen.add(resolved);
    for (const arg of resolved.args) pending.push(arg);
  }
  return true;
}

const graphicAtomChars = new Set('!#$&*+-/<=>@^~\\'.split(''));

function atomNeedsQuotes(name) {
  if (!name) return true;
  if (name === '[]' || name === '{}') return false;
  if (name === '\\+' || name === '+' || name === '-' || name === '\\') return true;
  if (/^[a-z][A-Za-z0-9_]*$/.test(name)) return false;
  for (const ch of name) if (!graphicAtomChars.has(ch)) return true;
  return false;
}

function quoteAtom(name) {
  let out = "'";
  for (const ch of name) {
    if (ch === "'") out += "''";
    else if (ch === '\\') out += '\\\\';
    else if (ch === '\n') out += '\\n';
    else if (ch === '\t') out += '\\t';
    else out += ch;
  }
  return out + "'";
}

function writeAtom(name) {
  return atomNeedsQuotes(name) ? quoteAtom(name) : name;
}

function legacyVariableToIso(name) {
  if (name === '?') return '_';
  const tail = name.slice(1);
  if (!tail) return '_';
  if (tail[0] === '_') return tail;
  return tail[0].toUpperCase() + tail.slice(1);
}

function writeVariable(name) {
  name = String(name ?? '');
  if (/^\?(?:[A-Za-z_][A-Za-z0-9_]*)?$/.test(name)) return legacyVariableToIso(name);
  if (/^(?:_|[A-Z_][A-Za-z0-9_]*)$/.test(name)) return name;
  const sanitized = name.replace(/[^A-Za-z0-9_]/g, '_');
  if (!sanitized) return '_';
  return /^[A-Z_]/.test(sanitized) ? sanitized : `_${sanitized}`;
}

function writeString(value, quoteStrings) {
  if (!quoteStrings) return value;
  let out = '"';
  for (const ch of value) {
    if (ch === '"' || ch === '\\') out += `\\${ch}`;
    else if (ch === '\n') out += '\\n';
    else out += ch;
  }
  return out + '"';
}

function writeList(term, env) {
  const parts = [];
  let cursor = term;
  while (true) {
    cursor = deref(cursor, env);
    if (isEmptyList(cursor)) return `[${parts.join(', ')}]`;
    if (!isCons(cursor)) {
      if (parts.length) return `[${parts.join(', ')} | ${termToString(cursor, env, true)}]`;
      return `[${termToString(cursor, env, true)}]`;
    }
    parts.push(termToString(cursor.args[0], env, true));
    cursor = cursor.args[1];
  }
}

export function termToString(term, env = new Env(), quoteStrings = true) {
  const resolved = deref(term, env);
  if (resolved.type === VAR) return writeVariable(resolved.name);
  if (isCons(resolved)) return writeList(resolved, env);
  if (resolved.type === STRING) return writeString(resolved.name, quoteStrings);
  if (resolved.type === ATOM) return writeAtom(resolved.name);
  if (resolved.type === NUMBER) return resolved.name;
  if (resolved.type === COMPOUND && resolved.arity === 0) return writeAtom(resolved.name);
  if (resolved.type === COMPOUND && resolved.name === '{}' && resolved.arity === 1) {
    return `{${termToString(resolved.args[0], env, true)}}`;
  }
  if (isConjunction(resolved)) {
    const parts = [];
    let cursor = resolved;
    while (true) {
      cursor = deref(cursor, env);
      if (isConjunction(cursor)) {
        parts.push(termToString(cursor.args[0], env, true));
        cursor = cursor.args[1];
      } else {
        parts.push(termToString(cursor, env, true));
        break;
      }
    }
    return `(${parts.join(', ')})`;
  }
  return `${writeAtom(resolved.name)}(${resolved.args.map((arg) => termToString(arg, env, true)).join(', ')})`;
}

export function lexicalValue(term, env) {
  const resolved = deref(term, env);
  if (resolved.type === VAR) return null;
  if (resolved.type === ATOM || resolved.type === STRING || resolved.type === NUMBER) return resolved.name;
  return termToString(resolved, env, true);
}

export function properListItems(list, env) {
  const items = [];
  let cursor = deref(list, env);
  while (isCons(cursor)) {
    items.push(cursor.args[0]);
    cursor = deref(cursor.args[1], env);
  }
  if (!isEmptyList(cursor)) return null;
  return items;
}

export function listFromItems(items, start = 0, end = items.length, tail = emptyList()) {
  let result = tail;
  for (let i = end - 1; i >= start; i--) result = cons(items[i], result);
  return result;
}

export function flattenConjunction(goal) {
  const out = [];
  const stack = [goal];
  while (stack.length) {
    const current = stack.pop();
    if (isConjunction(current)) {
      stack.push(current.args[1], current.args[0]);
    } else {
      out.push(current);
    }
  }
  return out;
}

export function termSignature(term) {
  return term?.type === COMPOUND ? `${term.name}/${term.arity}` : null;
}

export function variantTerms(left, leftEnv, right, rightEnv, pairs = new Map(), reverse = new Map()) {
  left = deref(left, leftEnv);
  right = deref(right, rightEnv);
  if (left.type === VAR || right.type === VAR) {
    if (left.type !== VAR || right.type !== VAR) return false;
    if (pairs.has(left.name) || reverse.has(right.name)) {
      return pairs.get(left.name) === right.name && reverse.get(right.name) === left.name;
    }
    pairs.set(left.name, right.name);
    reverse.set(right.name, left.name);
    return true;
  }
  if (left.type !== right.type || left.name !== right.name || left.arity !== right.arity) return false;
  for (let i = 0; i < left.arity; i++) {
    if (!variantTerms(left.args[i], leftEnv, right.args[i], rightEnv, pairs, reverse)) return false;
  }
  return true;
}

export function compareTerms(left, right) {
  const rank = (term) => ({ [VAR]: 0, [NUMBER]: 1, [ATOM]: 2, [STRING]: 3, [COMPOUND]: 4 })[term.type];
  left = deref(left, new Env());
  right = deref(right, new Env());
  const lr = rank(left);
  const rr = rank(right);
  if (lr !== rr) return lr < rr ? -1 : 1;
  if (left.type === NUMBER) {
    const leftInteger = isDecimalInteger(left.name);
    const rightInteger = isDecimalInteger(right.name);
    if (leftInteger !== rightInteger) return leftInteger ? 1 : -1;
    return compareNumberText(left.name, right.name);
  }
  if (left.type === VAR) {
    const leftOrder = left.order ?? 0;
    const rightOrder = right.order ?? 0;
    return leftOrder < rightOrder ? -1 : leftOrder > rightOrder ? 1 : 0;
  }
  if (left.type === ATOM || left.type === STRING) return left.name < right.name ? -1 : left.name > right.name ? 1 : 0;
  if (left.arity !== right.arity) return left.arity < right.arity ? -1 : 1;
  if (left.name !== right.name) return left.name < right.name ? -1 : 1;
  for (let i = 0; i < left.arity; i++) {
    const cmp = compareTerms(left.args[i], right.args[i]);
    if (cmp) return cmp;
  }
  return 0;
}

export function isDecimalInteger(text) {
  return /^-?\d+$/.test(text ?? '');
}

export function compareIntegerText(left, right) {
  const a = BigInt(left);
  const b = BigInt(right);
  return a < b ? -1 : a > b ? 1 : 0;
}

export function parseFiniteNumber(text) {
  if (text == null || text === '') return null;
  if (!/^[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$/.test(text)) return null;
  const n = Number(text);
  return Number.isFinite(n) ? n : null;
}

export function numberTextFromDouble(value) {
  if (!Number.isFinite(value)) return null;
  if (Object.is(value, -0)) value = 0;
  let text = Number(value).toPrecision(17);
  if (text.includes('e') || text.includes('E')) {
    text = text.replace(/(\.\d*?[1-9])0+(e[+-]?\d+)$/i, '$1$2').replace(/\.0+(e[+-]?\d+)$/i, '$1');
  } else if (text.includes('.')) {
    text = text.replace(/0+$/, '').replace(/\.$/, '');
  }
  if (!/[.eE]/.test(text)) text += '.0';
  return text;
}

export function compareNumberText(left, right) {
  if (isDecimalInteger(left) && isDecimalInteger(right)) return compareIntegerText(left, right);
  const a = parseFiniteNumber(left);
  const b = parseFiniteNumber(right);
  if (a != null && b != null) return a < b ? -1 : a > b ? 1 : 0;
  return left < right ? -1 : left > right ? 1 : 0;
}
