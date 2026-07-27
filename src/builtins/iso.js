// ISO/IEC 13211-1 core built-in predicates.
import {
  ATOM, COMPOUND, NUMBER, STRING, VAR,
  atom, compareTerms, compound, copyResolved, deref, emptyList,
  isDecimalInteger, listFromItems, numberTerm, numberTextFromDouble,
  properListItems, termIsGround, termToString, unify, variable,
} from '../term.js';

let isoFresh = 0;

export class PrologError extends Error {
  constructor(formal, culprit = null) {
    const detail = culprit == null ? formal : `${formal}, ${termToString(culprit)}`;
    super(`error(${detail})`);
    this.name = 'PrologError';
    this.formal = formal;
    this.culprit = culprit;
  }
}

const succeed = function* ({ env }) { yield env; };
const fail = function* () {};

export const isoBuiltins = {
  register(registry) {
    registry.add('true', 0, succeed, { deterministic: true });
    registry.add('fail', 0, fail, { deterministic: true });

    registry.add('=', 2, unification, { deterministic: true });
    registry.add('\\=', 2, nonUnification, { deterministic: true });
    registry.add('==', 2, identity, { deterministic: true });
    registry.add('\\==', 2, nonIdentity, { deterministic: true });

    for (const [name, test] of Object.entries(typeTests)) {
      registry.add(name, 1, test, { deterministic: true });
    }
    registry.add('compare', 3, compareBuiltin, { deterministic: true });
    registry.add('@<', 2, orderBuiltin((n) => n < 0), { deterministic: true });
    registry.add('@=<', 2, orderBuiltin((n) => n <= 0), { deterministic: true });
    registry.add('@>', 2, orderBuiltin((n) => n > 0), { deterministic: true });
    registry.add('@>=', 2, orderBuiltin((n) => n >= 0), { deterministic: true });

    registry.add('functor', 3, functorBuiltin, { deterministic: true });
    registry.add('arg', 3, argBuiltin, { deterministic: true });
    registry.add('=..', 2, univBuiltin, { deterministic: true });
    registry.add('copy_term', 2, copyTermBuiltin, { deterministic: true });
    registry.add('term_variables', 2, termVariablesBuiltin, { deterministic: true });
    registry.add('findall', 3, findallBuiltin);

    registry.add('call', 1, callBuiltin);
    registry.add('\\+', 1, negationBuiltin, { deterministic: true });
    registry.add(';', 2, disjunctionBuiltin);
    registry.add('->', 2, ifThenBuiltin);

    registry.add('is', 2, isBuiltin, { deterministic: true });
    registry.add('=:=', 2, arithmeticComparison((n) => n === 0), { deterministic: true });
    registry.add('=\\=', 2, arithmeticComparison((n) => n !== 0), { deterministic: true });
    registry.add('<', 2, arithmeticComparison((n) => n < 0), { deterministic: true });
    registry.add('=<', 2, arithmeticComparison((n) => n <= 0), { deterministic: true });
    registry.add('>', 2, arithmeticComparison((n) => n > 0), { deterministic: true });
    registry.add('>=', 2, arithmeticComparison((n) => n >= 0), { deterministic: true });
  }
};

function* unification({ goal, env }) {
  const next = env.clone();
  if (unify(goal.args[0], goal.args[1], next)) yield next;
}
function* nonUnification({ goal, env }) {
  if (!unify(goal.args[0], goal.args[1], env.clone())) yield env;
}
function* identity({ goal, env }) {
  if (identical(goal.args[0], goal.args[1], env)) yield env;
}
function* nonIdentity({ goal, env }) {
  if (!identical(goal.args[0], goal.args[1], env)) yield env;
}

function identical(left, right, env) {
  left = deref(left, env);
  right = deref(right, env);
  if (left.type !== right.type || left.name !== right.name || left.arity !== right.arity) return false;
  if (left.type === VAR) return left.name === right.name;
  for (let i = 0; i < left.arity; i++) if (!identical(left.args[i], right.args[i], env)) return false;
  return true;
}

const unaryTest = (predicate) => function* ({ goal, env }) {
  if (predicate(deref(goal.args[0], env), env)) yield env;
};
const typeTests = {
  var: unaryTest((t) => t.type === VAR),
  nonvar: unaryTest((t) => t.type !== VAR),
  atom: unaryTest((t) => t.type === ATOM),
  integer: unaryTest((t) => t.type === NUMBER && isDecimalInteger(t.name)),
  float: unaryTest((t) => t.type === NUMBER && !isDecimalInteger(t.name)),
  number: unaryTest((t) => t.type === NUMBER),
  atomic: unaryTest((t) => t.type === ATOM || t.type === NUMBER || t.type === STRING),
  compound: unaryTest((t) => t.type === COMPOUND),
  callable: unaryTest((t) => t.type === ATOM || t.type === COMPOUND),
  ground: unaryTest((t, env) => termIsGround(t, env)),
};

function resolvedOrder(left, right, env) {
  return compareTerms(copyResolved(left, env), copyResolved(right, env));
}
function* compareBuiltin({ goal, env }) {
  const cmp = resolvedOrder(goal.args[1], goal.args[2], env);
  const next = env.clone();
  if (unify(goal.args[0], atom(cmp < 0 ? '<' : cmp > 0 ? '>' : '='), next)) yield next;
}
function orderBuiltin(test) {
  return function* ({ goal, env }) {
    if (test(resolvedOrder(goal.args[0], goal.args[1], env))) yield env;
  };
}

function requireInteger(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  if (value.type !== NUMBER || !isDecimalInteger(value.name)) throw new PrologError('type_error(integer)', value);
  return BigInt(value.name);
}
function requireAtom(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  if (value.type !== ATOM) throw new PrologError('type_error(atom)', value);
  return value;
}

function* functorBuiltin({ goal, env }) {
  const term = deref(goal.args[0], env);
  const next = env.clone();
  if (term.type !== VAR) {
    const name = term.type === COMPOUND ? atom(term.name) : term;
    if (unify(goal.args[1], name, next) && unify(goal.args[2], numberTerm(term.arity), next)) yield next;
    return;
  }
  const name = deref(goal.args[1], env);
  const arity = requireInteger(goal.args[2], env);
  if (arity < 0n) throw new PrologError('domain_error(not_less_than_zero)', deref(goal.args[2], env));
  if (arity > BigInt(Number.MAX_SAFE_INTEGER)) throw new PrologError('representation_error(max_arity)');
  if (arity === 0n) {
    if (name.type === VAR) throw new PrologError('instantiation_error');
    if (name.type === COMPOUND) throw new PrologError('type_error(atomic)', name);
    if (unify(goal.args[0], name, next)) yield next;
    return;
  }
  if (name.type === VAR) throw new PrologError('instantiation_error');
  if (name.type !== ATOM) throw new PrologError('type_error(atom)', name);
  const id = ++isoFresh;
  if (unify(goal.args[0], compound(name.name, Array.from({ length: Number(arity) }, (_, i) => variable(`__functor${id}_${i}`))), next)) yield next;
}

function* argBuiltin({ goal, env }) {
  const index = requireInteger(goal.args[0], env);
  const term = deref(goal.args[1], env);
  if (term.type === VAR) throw new PrologError('instantiation_error');
  if (term.type !== COMPOUND) throw new PrologError('type_error(compound)', term);
  if (index < 0n) throw new PrologError('domain_error(not_less_than_zero)', deref(goal.args[0], env));
  if (index === 0n || index > BigInt(term.arity)) return;
  const next = env.clone();
  if (unify(goal.args[2], term.args[Number(index) - 1], next)) yield next;
}

function* univBuiltin({ goal, env }) {
  const term = deref(goal.args[0], env);
  const next = env.clone();
  if (term.type !== VAR) {
    const items = term.type === COMPOUND ? [atom(term.name), ...term.args] : [term];
    if (unify(goal.args[1], listFromItems(items), next)) yield next;
    return;
  }
  const items = properListItems(goal.args[1], env);
  if (items == null) {
    if (deref(goal.args[1], env).type === VAR) throw new PrologError('instantiation_error');
    throw new PrologError('type_error(list)', deref(goal.args[1], env));
  }
  if (items.length === 0) throw new PrologError('domain_error(non_empty_list)', emptyList());
  if (items.length === 1) {
    const scalar = deref(items[0], env);
    if (scalar.type === VAR) throw new PrologError('instantiation_error');
    if (scalar.type === COMPOUND) throw new PrologError('type_error(atomic)', scalar);
    if (unify(goal.args[0], scalar, next)) yield next;
    return;
  }
  const name = requireAtom(items[0], env);
  if (unify(goal.args[0], compound(name.name, items.slice(1)), next)) yield next;
}

function freshCopy(term, env, variables = new Map(), id = ++isoFresh) {
  term = deref(term, env);
  if (term.type === VAR) {
    if (!variables.has(term.name)) variables.set(term.name, variable(`__copy${id}_${variables.size}`));
    return variables.get(term.name);
  }
  if (term.type !== COMPOUND) return term;
  return compound(term.name, term.args.map((arg) => freshCopy(arg, env, variables, id)));
}
function* copyTermBuiltin({ goal, env }) {
  const next = env.clone();
  if (unify(goal.args[1], freshCopy(goal.args[0], env), next)) yield next;
}
function* termVariablesBuiltin({ goal, env }) {
  const found = [];
  const seen = new Set();
  const visit = (term) => {
    term = deref(term, env);
    if (term.type === VAR) {
      if (!seen.has(term.name)) { seen.add(term.name); found.push(term); }
    } else for (const arg of term.args) visit(arg);
  };
  visit(goal.args[0]);
  const next = env.clone();
  if (unify(goal.args[1], listFromItems(found), next)) yield next;
}

function* findallBuiltin({ solver, goal, env }) {
  const [template, innerGoal, bag] = goal.args;
  const collector = solver.cloneForInnerGoal(10000000);
  const collected = [];
  for (const answerEnv of collector.solve([callable(innerGoal, env)], env.clone(), 0)) {
    collected.push(freshCopy(template, answerEnv));
  }
  solver.absorbStatsFrom(collector);
  const next = env.clone();
  if (unify(bag, listFromItems(collected), next)) yield next;
}

function callable(term, env) {
  term = deref(term, env);
  if (term.type === VAR) throw new PrologError('instantiation_error');
  if (term.type !== ATOM && term.type !== COMPOUND) throw new PrologError('type_error(callable)', term);
  return term;
}
function* callBuiltin({ solver, goal, env }) {
  yield* solver.solve([callable(goal.args[0], env)], env, 0);
}
function* negationBuiltin({ solver, goal, env }) {
  for (const _ of solver.cloneForInnerGoal(1).solve([callable(goal.args[0], env)], env.clone(), 0)) return;
  yield env;
}
function* disjunctionBuiltin({ solver, goal, env }) {
  const left = deref(goal.args[0], env);
  if (left.type === COMPOUND && left.name === '->' && left.arity === 2) {
    for (const conditionEnv of solver.cloneForInnerGoal(1).solve([callable(left.args[0], env)], env.clone(), 0)) {
      yield* solver.solve([callable(left.args[1], conditionEnv)], conditionEnv, 0);
      return;
    }
    yield* solver.solve([callable(goal.args[1], env)], env.clone(), 0);
    return;
  }
  yield* solver.solve([callable(goal.args[0], env)], env.clone(), 0);
  yield* solver.solve([callable(goal.args[1], env)], env.clone(), 0);
}
function* ifThenBuiltin({ solver, goal, env }) {
  for (const conditionEnv of solver.cloneForInnerGoal(1).solve([callable(goal.args[0], env)], env.clone(), 0)) {
    yield* solver.solve([callable(goal.args[1], conditionEnv)], conditionEnv, 0);
    return;
  }
}

function evaluate(term, env) {
  term = deref(term, env);
  if (term.type === VAR) throw new PrologError('instantiation_error');
  if (term.type === NUMBER) {
    return isDecimalInteger(term.name)
      ? { integer: true, value: BigInt(term.name) }
      : { integer: false, value: Number(term.name) };
  }
  if (term.type === ATOM) {
    if (term.name === 'pi') return { integer: false, value: Math.PI };
    if (term.name === 'e') return { integer: false, value: Math.E };
  }
  if (term.type !== COMPOUND) throw new PrologError('type_error(evaluable)', term);
  const args = term.args.map((arg) => evaluate(arg, env));
  return evaluateOperation(term, args);
}
function evaluateOperation(term, args) {
  const name = term.name;
  const arity = term.arity;
  if (arity === 1 && (name === '+' || name === '-')) {
    return name === '+' ? args[0] : args[0].integer
      ? { integer: true, value: -args[0].value }
      : { integer: false, value: -args[0].value };
  }
  if (arity === 1 && ['abs', 'sign', 'float', 'truncate', 'round', 'ceiling', 'floor',
    'sin', 'cos', 'atan', 'exp', 'log', 'sqrt'].includes(name)) {
    const a = Number(args[0].value);
    if (name === 'abs' && args[0].integer) return { integer: true, value: args[0].value < 0n ? -args[0].value : args[0].value };
    if (name === 'sign' && args[0].integer) return { integer: true, value: args[0].value < 0n ? -1n : args[0].value > 0n ? 1n : 0n };
    if (name === 'truncate' || name === 'round' || name === 'ceiling' || name === 'floor') {
      const fn = name === 'truncate' ? Math.trunc : name === 'round' ? Math.round : name === 'ceiling' ? Math.ceil : Math.floor;
      return { integer: true, value: BigInt(fn(a)) };
    }
    const fn = name === 'float' ? (x) => x : name === 'abs' ? Math.abs : name === 'sign' ? Math.sign : Math[name];
    const value = fn(a);
    if (!Number.isFinite(value)) throw new PrologError('evaluation_error(undefined)');
    return { integer: false, value };
  }
  if (arity !== 2) throw new PrologError('type_error(evaluable)', compound('/', [atom(name), numberTerm(arity)]));
  const bothInteger = args[0].integer && args[1].integer;
  const a = args[0].value, b = args[1].value;
  if (bothInteger && name === '^' && b >= 0n) return { integer: true, value: a ** b };
  if (bothInteger && ['+', '-', '*', '//', 'div', 'mod', 'rem', '/\\', '\\/', '<<', '>>'].includes(name)) {
    if ((name === '//' || name === 'div' || name === 'mod' || name === 'rem') && b === 0n) throw new PrologError('evaluation_error(zero_divisor)');
    if (name === '+') return { integer: true, value: a + b };
    if (name === '-') return { integer: true, value: a - b };
    if (name === '*') return { integer: true, value: a * b };
    if (name === '//' || name === 'div') return { integer: true, value: a / b };
    if (name === 'rem') return { integer: true, value: a % b };
    if (name === 'mod') return { integer: true, value: ((a % b) + b) % b };
    if (name === '/\\') return { integer: true, value: a & b };
    if (name === '\\/') return { integer: true, value: a | b };
    if (name === '<<') return { integer: true, value: a << b };
    if (name === '>>') return { integer: true, value: a >> b };
  }
  const x = Number(a), y = Number(b);
  if (name === '/' && y === 0) throw new PrologError('evaluation_error(zero_divisor)');
  let value;
  if (name === '+') value = x + y;
  else if (name === '-') value = x - y;
  else if (name === '*') value = x * y;
  else if (name === '/') value = x / y;
  else if (name === '**' || name === '^') value = Math.pow(x, y);
  else if (name === 'min') value = Math.min(x, y);
  else if (name === 'max') value = Math.max(x, y);
  else if (name === 'atan2') value = Math.atan2(x, y);
  else throw new PrologError('type_error(evaluable)', compound('/', [atom(name), numberTerm(arity)]));
  if (!Number.isFinite(value)) throw new PrologError('evaluation_error(undefined)');
  return { integer: false, value };
}
function numericTerm(value) {
  return value.integer ? numberTerm(value.value.toString()) : numberTerm(numberTextFromDouble(value.value));
}
function* isBuiltin({ goal, env }) {
  const result = numericTerm(evaluate(goal.args[1], env));
  const next = env.clone();
  if (unify(goal.args[0], result, next)) yield next;
}
function arithmeticComparison(test) {
  return function* ({ goal, env }) {
    const left = evaluate(goal.args[0], env);
    const right = evaluate(goal.args[1], env);
    const a = left.value, b = right.value;
    const cmp = left.integer && right.integer ? (a < b ? -1 : a > b ? 1 : 0)
      : Number(a) < Number(b) ? -1 : Number(a) > Number(b) ? 1 : 0;
    if (test(cmp)) yield env;
  };
}
