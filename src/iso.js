// Built-ins in Eyelang's documented ISO compatibility profile. This is a
// deliberately incomplete profile, not the complete standard environment.
import {
  ATOM, COMPOUND, NUMBER, STRING, VAR, Env,
  atom, compareTerms, compound, copyResolved, deref, emptyList,
  isDecimalInteger, listFromItems, numberTerm, numberTextFromDouble,
  properListItems, termIsGround, termToString, unify, variable, variantTerms,
} from './term.js';
import { createParserOperatorState, parseClauses } from './parser.js';
import { formatTermForWrite } from './write.js';

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

export class HaltSignal extends Error {
  constructor(code = 0) {
    super(`halt(${code})`);
    this.name = 'HaltSignal';
    this.code = code;
  }
}

class ThrownTerm extends Error {
  constructor(term) {
    super(`uncaught exception: ${termToString(term)}`);
    this.name = 'ThrownTerm';
    this.term = term;
  }
}

const succeed = function* ({ env }) { yield env; };
const fail = function* () {};

export const isoBuiltins = {
  register(registry) {
    registry.add('true', 0, succeed, { deterministic: true });
    registry.add('fail', 0, fail, { deterministic: true });
    registry.add('false', 0, fail, { deterministic: true });
    registry.add('!', 0, succeed, { deterministic: true });

    registry.add('=', 2, unification, { deterministic: true });
    registry.add('unify_with_occurs_check', 2, unification, { deterministic: true });
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
    registry.add('bagof', 3, bagofBuiltin);
    registry.add('setof', 3, setofBuiltin);
    registry.add('clause', 2, clauseBuiltin, {
      shouldUse: ({ solver }) => solver.program.findGroup('clause', 2) == null,
    });
    registry.add('asserta', 1, assertBuiltin(true), { deterministic: true });
    registry.add('assertz', 1, assertBuiltin(false), { deterministic: true });
    registry.add('retract', 1, retractBuiltin);
    registry.add('abolish', 1, abolishBuiltin, { deterministic: true });
    registry.add('current_predicate', 1, currentPredicateBuiltin);
    registry.add('current_prolog_flag', 2, currentPrologFlagBuiltin);
    registry.add('set_prolog_flag', 2, setPrologFlagBuiltin, { deterministic: true });
    registry.add('op', 3, opBuiltin, {
      deterministic: true,
      shouldUse: ({ solver }) => solver.program.findGroup('op', 3) == null,
    });
    registry.add('current_op', 3, currentOpBuiltin);
    registry.add('char_conversion', 2, charConversionBuiltin, { deterministic: true });
    registry.add('current_char_conversion', 2, currentCharConversionBuiltin);
    registry.add('halt', 0, haltBuiltin, { deterministic: true });
    registry.add('halt', 1, haltBuiltin, { deterministic: true });

    registry.add('open', 3, openBuiltin, { deterministic: true });
    registry.add('open', 4, openBuiltin, { deterministic: true });
    registry.add('close', 1, closeBuiltin, { deterministic: true });
    registry.add('close', 2, closeBuiltin, { deterministic: true });
    registry.add('current_input', 1, currentInputBuiltin, { deterministic: true });
    registry.add('current_output', 1, currentOutputBuiltin, { deterministic: true });
    registry.add('set_input', 1, setCurrentStreamBuiltin('read'), { deterministic: true });
    registry.add('set_output', 1, setCurrentStreamBuiltin('write'), { deterministic: true });
    registry.add('flush_output', 0, succeed, { deterministic: true });
    registry.add('flush_output', 1, flushOutputBuiltin, { deterministic: true });
    registry.add('stream_property', 2, streamPropertyBuiltin);
    registry.add('set_stream_position', 2, setStreamPositionBuiltin, { deterministic: true });
    registry.add('at_end_of_stream', 0, atEndBuiltin, { deterministic: true });
    registry.add('at_end_of_stream', 1, atEndBuiltin, { deterministic: true });
    for (const name of ['get_char', 'peek_char', 'get_code', 'peek_code', 'get_byte', 'peek_byte']) {
      registry.add(name, 1, inputUnitBuiltin(name), { deterministic: true });
      registry.add(name, 2, inputUnitBuiltin(name), { deterministic: true });
    }
    for (const name of ['put_char', 'put_code', 'put_byte']) {
      registry.add(name, 1, outputUnitBuiltin(name), { deterministic: true });
      registry.add(name, 2, outputUnitBuiltin(name), { deterministic: true });
    }
    registry.add('nl', 0, nlBuiltin, { deterministic: true });
    registry.add('nl', 1, nlBuiltin, { deterministic: true });
    registry.add('read', 1, readBuiltin, { deterministic: true });
    registry.add('read', 2, readBuiltin, { deterministic: true });
    registry.add('read_term', 2, readTermBuiltin, { deterministic: true });
    registry.add('read_term', 3, readTermBuiltin, { deterministic: true });
    for (const [name, mode] of [
      ['write', 'write'],
      ['writeq', 'writeq'],
      ['write_canonical', 'canonical'],
    ]) {
      registry.add(name, 1, writeBuiltin(mode), { deterministic: true });
      registry.add(name, 2, writeBuiltin(mode), { deterministic: true });
    }
    registry.add('write_term', 2, writeTermBuiltin, { deterministic: true });
    registry.add('write_term', 3, writeTermBuiltin, { deterministic: true });

    registry.add('atom_length', 2, atomLengthBuiltin, { deterministic: true });
    registry.add('atom_concat', 3, atomConcatBuiltin);
    registry.add('sub_atom', 5, subAtomBuiltin);
    registry.add('atom_chars', 2, atomCharsBuiltin, { deterministic: true });
    registry.add('atom_codes', 2, atomCodesBuiltin, { deterministic: true });
    registry.add('char_code', 2, charCodeBuiltin, { deterministic: true });
    registry.add('number_chars', 2, numberCharsBuiltin, { deterministic: true });
    registry.add('number_codes', 2, numberCodesBuiltin, { deterministic: true });

    registry.add('call', 1, callBuiltin);
    registry.add('catch', 3, catchBuiltin);
    registry.add('throw', 1, throwBuiltin, { deterministic: true });
    registry.add('\\+', 1, negationBuiltin, { deterministic: true });
    registry.add('once', 1, onceBuiltin, { deterministic: true });
    registry.add('repeat', 0, repeatBuiltin);
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
  const order = deref(goal.args[0], env);
  if (order.type !== VAR) {
    if (order.type !== ATOM) throw new PrologError('type_error(atom)', order);
    if (!['<', '=', '>'].includes(order.name)) throw new PrologError('domain_error(order)', order);
  }
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
    if (isPartialList(goal.args[1], env)) throw new PrologError('instantiation_error');
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

function isPartialList(list, env) {
  let cursor = deref(list, env);
  while (cursor.type === COMPOUND && cursor.name === '.' && cursor.arity === 2) {
    cursor = deref(cursor.args[1], env);
  }
  return cursor.type === VAR;
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
  let list = deref(goal.args[1], env);
  while (list.type === COMPOUND && list.name === '.' && list.arity === 2) {
    list = deref(list.args[1], env);
  }
  if (list.type !== VAR && !(list.type === ATOM && list.name === '[]')) {
    throw new PrologError('type_error(list)', deref(goal.args[1], env));
  }
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

function validPredicateIndicator(term) {
  return term.type === COMPOUND && term.name === '/' && term.arity === 2 &&
    (term.args[0].type === VAR || term.args[0].type === ATOM) &&
    (term.args[1].type === VAR ||
      (term.args[1].type === NUMBER && isDecimalInteger(term.args[1].name) && BigInt(term.args[1].name) >= 0n));
}

function* currentPredicateBuiltin({ solver, goal, env }) {
  const indicator = copyResolved(goal.args[0], env);
  if (indicator.type !== VAR && !validPredicateIndicator(indicator)) {
    throw new PrologError('type_error(predicate_indicator)', indicator);
  }
  for (const group of solver.program.groups.values()) {
    const next = env.clone();
    const candidate = compound('/', [atom(group.name), numberTerm(group.arity)]);
    if (unify(goal.args[0], candidate, next)) yield next;
  }
}

function callableOrVariable(term, env) {
  const value = deref(term, env);
  if (value.type === VAR || value.type === ATOM || value.type === COMPOUND) return value;
  throw new PrologError('type_error(callable)', value);
}

function clauseBodyTerm(body) {
  if (body.length === 0) return atom('true');
  let result = body[body.length - 1];
  for (let i = body.length - 2; i >= 0; i--) result = compound(',', [body[i], result]);
  return result;
}

function* clauseBuiltin({ solver, goal, env }) {
  const head = deref(goal.args[0], env);
  if (head.type === VAR) throw new PrologError('instantiation_error');
  if (head.type !== ATOM && head.type !== COMPOUND) throw new PrologError('type_error(callable)', head);
  callableOrVariable(goal.args[1], env);
  const indicator = compound('/', [atom(head.name), numberTerm(head.arity)]);
  if (solver.registry.get(head.name, head.arity)) {
    throw new PrologError('permission_error(access, private_procedure)', indicator);
  }
  const group = solver.program.findGroup(head.name, head.arity);
  if (!group) return;
  for (const clause of group.clauses) {
    const pair = compound('$clause', [clause.head, clauseBodyTerm(clause.body)]);
    const copied = freshCopy(pair, new Env());
    const next = env.clone();
    if (unify(goal.args[0], copied.args[0], next) && unify(goal.args[1], copied.args[1], next)) yield next;
  }
}

function clauseParts(term, env) {
  const value = deref(term, env);
  if (value.type === COMPOUND && value.name === ':-' && value.arity === 2) {
    return { head: deref(value.args[0], env), body: deref(value.args[1], env), rule: true };
  }
  return { head: value, body: atom('true'), rule: false };
}

function requireClauseHead(head) {
  if (head.type === VAR) throw new PrologError('instantiation_error');
  if (head.type !== ATOM && head.type !== COMPOUND) throw new PrologError('type_error(callable)', head);
}

function convertAssertedBody(term) {
  if (term.type === VAR) return compound('call', [term]);
  if (term.type === COMPOUND && term.name === ',' && term.arity === 2) {
    return compound(',', [convertAssertedBody(term.args[0]), convertAssertedBody(term.args[1])]);
  }
  if (term.type !== ATOM && term.type !== COMPOUND) throw new PrologError('type_error(callable)', term);
  return term;
}

function procedureIndicator(head) {
  return compound('/', [atom(head.name), numberTerm(head.arity)]);
}

function assertModifiable(solver, head) {
  const group = solver.program.findGroup(head.name, head.arity);
  if (solver.registry.get(head.name, head.arity) || (group && !group.dynamic)) {
    throw new PrologError('permission_error(modify, static_procedure)', procedureIndicator(head));
  }
}

function assertBuiltin(atStart) {
  return function* ({ solver, goal, env }) {
    const parts = clauseParts(goal.args[0], env);
    requireClauseHead(parts.head);
    const body = convertAssertedBody(parts.body);
    assertModifiable(solver, parts.head);
    const copied = freshCopy(compound('$clause', [parts.head, body]), env);
    solver.program.insertDynamicClause({
      head: copied.args[0],
      body: copied.args[1].type === ATOM && copied.args[1].name === 'true'
        ? []
        : [copied.args[1]],
    }, atStart);
    yield env;
  };
}

function* retractBuiltin({ solver, goal, env }) {
  const parts = clauseParts(goal.args[0], env);
  requireClauseHead(parts.head);
  const group = solver.program.findGroup(parts.head.name, parts.head.arity);
  if (solver.registry.get(parts.head.name, parts.head.arity) || (group && !group.dynamic)) {
    throw new PrologError('permission_error(access, static_procedure)', procedureIndicator(parts.head));
  }
  if (!group) return;
  // ISO logical update view: this call keeps the clauses that were visible
  // when it began. A later retract/1 may erase one of those clauses from the
  // live procedure, but must not invalidate this call's pending alternatives.
  const candidates = [...group.clauses];
  for (const clause of candidates) {
    const copied = freshCopy(compound('$clause', [clause.head, clauseBodyTerm(clause.body)]), new Env());
    const next = env.clone();
    if (!unify(parts.head, copied.args[0], next)) continue;
    if (parts.rule && !unify(parts.body, copied.args[1], next)) continue;
    if (!parts.rule && !(copied.args[1].type === ATOM && copied.args[1].name === 'true')) continue;
    solver.program.removeDynamicClause(group, clause);
    yield next;
  }
}

function predicateIndicatorParts(term, env) {
  const indicator = deref(term, env);
  if (indicator.type === VAR) throw new PrologError('instantiation_error');
  if (indicator.type !== COMPOUND || indicator.name !== '/' || indicator.arity !== 2) {
    throw new PrologError('type_error(predicate_indicator)', indicator);
  }
  const name = deref(indicator.args[0], env);
  const arity = deref(indicator.args[1], env);
  if (name.type === VAR || arity.type === VAR) throw new PrologError('instantiation_error');
  if (arity.type !== NUMBER || !isDecimalInteger(arity.name)) throw new PrologError('type_error(integer)', arity);
  if (name.type !== ATOM) throw new PrologError('type_error(atom)', name);
  const integer = BigInt(arity.name);
  if (integer < 0n) throw new PrologError('domain_error(not_less_than_zero)', arity);
  if (integer > BigInt(Number.MAX_SAFE_INTEGER)) throw new PrologError('representation_error(max_arity)');
  return { name: name.name, arity: Number(integer), indicator };
}

function* abolishBuiltin({ solver, goal, env }) {
  const target = predicateIndicatorParts(goal.args[0], env);
  const group = solver.program.findGroup(target.name, target.arity);
  if (solver.registry.get(target.name, target.arity) || (group && !group.dynamic)) {
    throw new PrologError('permission_error(modify, static_procedure)', target.indicator);
  }
  solver.program.abolishDynamicGroup(target.name, target.arity);
  yield env;
}

function* currentPrologFlagBuiltin({ solver, goal, env }) {
  const flag = deref(goal.args[0], env);
  if (flag.type !== VAR && flag.type !== ATOM) throw new PrologError('type_error(atom)', flag);
  if (flag.type === ATOM && !solver.prologFlags.has(flag.name)) {
    throw new PrologError('domain_error(prolog_flag)', flag);
  }
  for (const [name, definition] of solver.prologFlags) {
    const next = env.clone();
    if (unify(goal.args[0], atom(name), next) && unify(goal.args[1], definition.value, next)) yield next;
  }
}

function* setPrologFlagBuiltin({ solver, goal, env }) {
  const flag = deref(goal.args[0], env);
  const value = deref(goal.args[1], env);
  if (flag.type === VAR || value.type === VAR) throw new PrologError('instantiation_error');
  if (flag.type !== ATOM) throw new PrologError('type_error(atom)', flag);
  const definition = solver.prologFlags.get(flag.name);
  if (!definition) throw new PrologError('domain_error(prolog_flag)', flag);
  if (value.type !== ATOM || !definition.allowed.includes(value.name)) {
    throw new PrologError('domain_error(flag_value)', compound('+', [flag, value]));
  }
  if (!definition.changeable) throw new PrologError('permission_error(modify, flag)', flag);
  definition.value = atom(value.name);
  yield env;
}

const operatorSpecifiers = new Set(['fx', 'fy', 'xf', 'yf', 'xfx', 'xfy', 'yfx']);

function operatorPriority(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  if (value.type !== NUMBER || !isDecimalInteger(value.name)) throw new PrologError('type_error(integer)', value);
  const priority = BigInt(value.name);
  if (priority < 0n || priority > 1200n) throw new PrologError('domain_error(operator_priority)', value);
  return Number(priority);
}

function operatorSpecifier(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  if (value.type !== ATOM) throw new PrologError('type_error(atom)', value);
  if (!operatorSpecifiers.has(value.name)) throw new PrologError('domain_error(operator_specifier)', value);
  return value.name;
}

function operatorNames(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  if (value.type === ATOM) return [value];
  const items = properListItems(value, env);
  if (items == null) {
    if (isPartialList(value, env)) throw new PrologError('instantiation_error');
    throw new PrologError('type_error(list)', value);
  }
  for (const item of items) {
    const resolved = deref(item, env);
    if (resolved.type === VAR) throw new PrologError('instantiation_error');
    if (resolved.type !== ATOM) throw new PrologError('type_error(atom)', resolved);
  }
  return items.map((item) => deref(item, env));
}

function* opBuiltin({ solver, goal, env }) {
  const priority = operatorPriority(goal.args[0], env);
  const specifier = operatorSpecifier(goal.args[1], env);
  for (const name of operatorNames(goal.args[2], env)) {
    if (name.name === ',' || name.name === '|') {
      throw new PrologError('permission_error(modify, operator)', name);
    }
    solver.program.defineOperator(priority, specifier, name.name);
  }
  yield env;
}

function* currentOpBuiltin({ solver, goal, env }) {
  const priority = deref(goal.args[0], env);
  const specifier = deref(goal.args[1], env);
  const name = deref(goal.args[2], env);
  if (priority.type !== VAR) {
    if (priority.type !== NUMBER || !isDecimalInteger(priority.name)) {
      throw new PrologError('type_error(integer)', priority);
    }
    if (BigInt(priority.name) < 0n || BigInt(priority.name) > 1200n) {
      throw new PrologError('domain_error(operator_priority)', priority);
    }
  }
  if (specifier.type !== VAR) {
    if (specifier.type !== ATOM) throw new PrologError('type_error(atom)', specifier);
    if (!operatorSpecifiers.has(specifier.name)) {
      throw new PrologError('domain_error(operator_specifier)', specifier);
    }
  }
  if (name.type !== VAR && name.type !== ATOM) throw new PrologError('type_error(atom)', name);
  for (const definition of solver.program.operators.values()) {
    const next = env.clone();
    if (unify(goal.args[0], numberTerm(definition.priority), next) &&
        unify(goal.args[1], atom(definition.specifier), next) &&
        unify(goal.args[2], atom(definition.name), next)) yield next;
  }
}

function conversionCharacter(term, env, current = false) {
  const value = deref(term, env);
  if (value.type === VAR) {
    if (current) return value;
    throw new PrologError('instantiation_error');
  }
  if (!oneChar(value)) {
    if (current) throw new PrologError('type_error(character)', value);
    throw new PrologError('representation_error(character)');
  }
  return value;
}
function* charConversionBuiltin({ solver, goal, env }) {
  const input = conversionCharacter(goal.args[0], env);
  const output = conversionCharacter(goal.args[1], env);
  if (input.name === output.name) solver.charConversions.delete(input.name);
  else solver.charConversions.set(input.name, output.name);
  yield env;
}
function* currentCharConversionBuiltin({ solver, goal, env }) {
  const input = conversionCharacter(goal.args[0], env, true);
  const output = conversionCharacter(goal.args[1], env, true);
  for (const [from, to] of [...solver.charConversions]) {
    const next = env.clone();
    if (unify(input, atom(from), next) && unify(output, atom(to), next)) yield next;
  }
}
function* haltBuiltin({ goal, env }) {
  const code = goal.arity === 0 ? 0n : requireInteger(goal.args[0], env);
  throw new HaltSignal(Number(code));
}

function streamHandle(id) {
  return compound('$stream', [numberTerm(id)]);
}

function streamReference(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  if (value.type === ATOM) return value.name;
  if (value.type === COMPOUND && value.name === '$stream' && value.arity === 1 &&
      value.args[0].type === NUMBER && isDecimalInteger(value.args[0].name)) {
    return Number(value.args[0].name);
  }
  throw new PrologError('domain_error(stream_or_alias)', value);
}

function requireStream(solver, term, env, mode = null) {
  const culprit = deref(term, env);
  const stream = solver.io.resolve(streamReference(term, env));
  if (!stream) throw new PrologError('existence_error(stream)', culprit);
  if (mode && stream.mode !== mode && !(mode === 'write' && stream.mode === 'append')) {
    throw new PrologError(`permission_error(${mode === 'read' ? 'input' : 'output'}, stream)`, culprit);
  }
  return stream;
}

function optionList(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  const items = properListItems(value, env);
  if (items == null) {
    if (isPartialList(value, env)) throw new PrologError('instantiation_error');
    throw new PrologError('type_error(list)', value);
  }
  return items.map((item) => deref(item, env));
}

function optionAtom(option, name) {
  if (option.type !== COMPOUND || option.name !== name || option.arity !== 1) return null;
  return option.args[0];
}

function openOptions(term, env) {
  const result = {};
  for (const option of optionList(term, env)) {
    let value;
    if ((value = optionAtom(option, 'type'))) {
      value = deref(value, env);
      if (value.type === VAR) throw new PrologError('instantiation_error');
      if (value.type !== ATOM) throw new PrologError('type_error(atom)', value);
      if (!['text', 'binary'].includes(value.name)) throw new PrologError('domain_error(stream_option)', option);
      result.type = value.name;
    } else if ((value = optionAtom(option, 'alias'))) {
      value = deref(value, env);
      if (value.type === VAR) throw new PrologError('instantiation_error');
      if (value.type !== ATOM) throw new PrologError('type_error(atom)', value);
      result.alias = value.name;
    } else if ((value = optionAtom(option, 'reposition'))) {
      value = deref(value, env);
      if (value.type !== ATOM || !['true', 'false'].includes(value.name)) throw new PrologError('domain_error(stream_option)', option);
      result.reposition = value.name === 'true';
    } else if ((value = optionAtom(option, 'eof_action'))) {
      value = deref(value, env);
      if (value.type !== ATOM || !['error', 'eof_code', 'reset'].includes(value.name)) throw new PrologError('domain_error(stream_option)', option);
      result.eof_action = value.name;
    } else {
      throw new PrologError('domain_error(stream_option)', option);
    }
  }
  return result;
}

function* openBuiltin({ solver, goal, env }) {
  const path = requireAtom(goal.args[0], env);
  const mode = requireAtom(goal.args[1], env);
  if (!['read', 'write', 'append'].includes(mode.name)) throw new PrologError('domain_error(io_mode)', mode);
  const options = goal.arity === 3 ? {} : openOptions(goal.args[3], env);
  if (options.alias && solver.io.resolve(options.alias)) throw new PrologError('permission_error(open, source_sink)', atom(options.alias));
  let stream;
  try {
    stream = solver.io.open(path.name, mode.name, options);
  } catch (_) {
    throw new PrologError('existence_error(source_sink)', path);
  }
  const next = env.clone();
  if (unify(goal.args[2], streamHandle(stream.id), next)) yield next;
  else solver.io.close(stream);
}

function* closeBuiltin({ solver, goal, env }) {
  if (goal.arity === 2) {
    for (const option of optionList(goal.args[1], env)) {
      const force = optionAtom(option, 'force');
      const value = force && deref(force, env);
      if (!value || value.type !== ATOM || !['true', 'false'].includes(value.name)) {
        throw new PrologError('domain_error(close_option)', option);
      }
    }
  }
  const stream = requireStream(solver, goal.args[0], env);
  if (!stream.standard) {
    if (solver.io.currentInput === stream.id) solver.io.currentInput = 0;
    if (solver.io.currentOutput === stream.id) solver.io.currentOutput = 1;
    solver.io.close(stream);
  }
  yield env;
}

function* currentInputBuiltin({ solver, goal, env }) {
  const value = deref(goal.args[0], env);
  if (value.type !== VAR) {
    const stream = solver.io.resolve(streamReference(goal.args[0], env));
    if (!stream) throw new PrologError('domain_error(stream)', value);
    if (stream.id === solver.io.currentInput) yield env;
    return;
  }
  const next = env.clone();
  if (unify(goal.args[0], streamHandle(solver.io.currentInput), next)) yield next;
}
function* currentOutputBuiltin({ solver, goal, env }) {
  const value = deref(goal.args[0], env);
  if (value.type !== VAR) {
    const stream = solver.io.resolve(streamReference(goal.args[0], env));
    if (!stream) throw new PrologError('domain_error(stream)', value);
    if (stream.id === solver.io.currentOutput) yield env;
    return;
  }
  const next = env.clone();
  if (unify(goal.args[0], streamHandle(solver.io.currentOutput), next)) yield next;
}
function setCurrentStreamBuiltin(mode) {
  return function* ({ solver, goal, env }) {
    const stream = requireStream(solver, goal.args[0], env, mode);
    if (mode === 'read') solver.io.currentInput = stream.id;
    else solver.io.currentOutput = stream.id;
    yield env;
  };
}
function* flushOutputBuiltin({ solver, goal, env }) {
  requireStream(solver, goal.args[0], env, 'write');
  yield env;
}

function streamProperties(stream) {
  const properties = [
    compound('mode', [atom(stream.mode)]),
    compound('type', [atom(stream.type)]),
    compound('reposition', [atom(stream.reposition ? 'true' : 'false')]),
    compound('eof_action', [atom(stream.eofAction)]),
    compound('position', [numberTerm(stream.position)]),
  ];
  properties.push(atom(stream.mode === 'read' ? 'input' : 'output'));
  properties.push(compound('end_of_stream', [
    atom(stream.pastEnd ? 'past' : stream.position >= stream.content.length ? 'at' : 'not'),
  ]));
  if (stream.alias) properties.push(compound('alias', [atom(stream.alias)]));
  if (stream.path) properties.push(compound('file_name', [atom(stream.path)]));
  return properties;
}
function* setStreamPositionBuiltin({ solver, goal, env }) {
  const stream = requireStream(solver, goal.args[0], env);
  if (!stream.reposition) throw new PrologError('permission_error(reposition, stream)', deref(goal.args[0], env));
  let position = deref(goal.args[1], env);
  if (position.type === COMPOUND && position.name === 'position' && position.arity === 1) {
    position = deref(position.args[0], env);
  }
  if (position.type === VAR) throw new PrologError('instantiation_error');
  if (position.type !== NUMBER || !isDecimalInteger(position.name)) throw new PrologError('domain_error(stream_position)', position);
  const offset = BigInt(position.name);
  if (offset < 0n || offset > BigInt(stream.content.length)) throw new PrologError('domain_error(stream_position)', position);
  stream.position = Number(offset);
  stream.pastEnd = false;
  yield env;
}
function* streamPropertyBuiltin({ solver, goal, env }) {
  const reference = deref(goal.args[0], env);
  const streams = reference.type === VAR ? [...solver.io.streams.values()] : [requireStream(solver, goal.args[0], env)];
  for (const stream of streams) {
    for (const property of streamProperties(stream)) {
      const next = env.clone();
      if (unify(goal.args[0], streamHandle(stream.id), next) && unify(goal.args[1], property, next)) yield next;
    }
  }
}

function inputStreamFor(solver, goal, env) {
  return goal.arity === 1 ? solver.io.resolve(solver.io.currentInput) : requireStream(solver, goal.args[0], env, 'read');
}
function outputStreamFor(solver, goal, env) {
  return goal.arity === 1 ? solver.io.resolve(solver.io.currentOutput) : requireStream(solver, goal.args[0], env, 'write');
}
function* atEndBuiltin({ solver, goal, env }) {
  const stream = goal.arity === 0 ? solver.io.resolve(solver.io.currentInput) : requireStream(solver, goal.args[0], env, 'read');
  if (stream.position >= stream.content.length) yield env;
}
function inputUnitBuiltin(name) {
  return function* ({ solver, goal, env }) {
    const stream = inputStreamFor(solver, goal, env);
    const binary = name.endsWith('byte');
    if (binary !== (stream.type === 'binary')) throw new PrologError('permission_error(input, stream)', streamHandle(stream.id));
    if (stream.pastEnd && stream.eofAction === 'error') {
      throw new PrologError('permission_error(input, past_end_of_stream)', streamHandle(stream.id));
    }
    if (stream.pastEnd && stream.eofAction === 'reset') {
      stream.position = 0;
      stream.pastEnd = false;
    }
    const peek = name.startsWith('peek');
    const unit = solver.io.readUnit(stream, peek);
    if (unit == null && !peek) stream.pastEnd = true;
    const result = unit == null ? (binary ? numberTerm(-1) : name.endsWith('code') ? numberTerm(-1) : atom('end_of_file'))
      : binary ? numberTerm(unit) : name.endsWith('code') ? numberTerm(unit.codePointAt(0)) : atom(unit);
    const target = goal.args[goal.arity - 1];
    const next = env.clone();
    if (unify(target, result, next)) yield next;
  };
}
function outputUnitBuiltin(name) {
  return function* ({ solver, goal, env }) {
    const stream = outputStreamFor(solver, goal, env);
    const value = deref(goal.args[goal.arity - 1], env);
    if (value.type === VAR) throw new PrologError('instantiation_error');
    if (name === 'put_char') {
      if (stream.type !== 'text') throw new PrologError('permission_error(output, binary_stream)', streamHandle(stream.id));
      if (!oneChar(value)) throw new PrologError('type_error(character)', value);
      solver.io.writeUnit(stream, value.name);
    } else {
      if ((name === 'put_byte') !== (stream.type === 'binary')) {
        throw new PrologError('permission_error(output, stream)', streamHandle(stream.id));
      }
      if (value.type !== NUMBER || !isDecimalInteger(value.name)) throw new PrologError('type_error(integer)', value);
      const code = BigInt(value.name);
      const max = name === 'put_byte' ? 255n : 0x10ffffn;
      if (code < 0n || code > max) throw new PrologError(name === 'put_byte' ? 'type_error(byte)' : 'representation_error(character_code)');
      solver.io.writeUnit(stream, name === 'put_byte' ? Number(code) : String.fromCodePoint(Number(code)));
    }
    yield env;
  };
}
function* nlBuiltin({ solver, goal, env }) {
  const stream = goal.arity === 0
    ? solver.io.resolve(solver.io.currentOutput)
    : requireStream(solver, goal.args[0], env, 'write');
  if (stream.type !== 'text') throw new PrologError('permission_error(output, binary_stream)', streamHandle(stream.id));
  solver.io.writeUnit(stream, '\n');
  yield env;
}

function isTerminatingFullStop(source, index) {
  const previous = source[index - 1] ?? '';
  const next = source[index + 1] ?? '';
  if (previous === '.' || next === '.') return false;
  if (/\d/.test(previous) && /\d/.test(next)) return false;
  if (/[A-Za-z0-9_]/.test(previous) && /[A-Za-z0-9_]/.test(next)) return false;
  return true;
}

function* termTextCandidates(stream) {
  const source = String(stream.content);
  let quote = null, escaped = false, lineComment = false, blockComment = false;
  for (let i = stream.position; i < source.length; i++) {
    const ch = source[i], next = source[i + 1];
    if (lineComment) { if (ch === '\n') lineComment = false; continue; }
    if (blockComment) { if (ch === '*' && next === '/') { blockComment = false; i++; } continue; }
    if (quote) {
      if (escaped) escaped = false;
      else if (ch === '\\') escaped = true;
      else if (ch === quote && next === quote) i++;
      else if (ch === quote) quote = null;
      continue;
    }
    if (ch === '%') { lineComment = true; continue; }
    if (ch === '/' && next === '*') { blockComment = true; i++; continue; }
    if (ch === "'" || ch === '"') { quote = ch; continue; }
    if (ch === '.' && isTerminatingFullStop(source, i)) {
      yield { text: source.slice(stream.position, i + 1), end: i + 1 };
    }
  }
}
function convertedTermText(text, solver) {
  if (solver.prologFlags.get('char_conversion')?.value?.name !== 'on' || solver.charConversions.size === 0) return text;
  let result = '', quote = null, escaped = false;
  for (const ch of text) {
    if (quote) {
      result += ch;
      if (escaped) escaped = false;
      else if (ch === '\\') escaped = true;
      else if (ch === quote) quote = null;
    } else if (ch === "'" || ch === '"') {
      quote = ch;
      result += ch;
    } else {
      result += solver.charConversions.get(ch) ?? ch;
    }
  }
  return result;
}
function readTermFromStream(stream, solver) {
  let sawCandidate = false;
  for (const candidate of termTextCandidates(stream)) {
    sawCandidate = true;
    try {
      const operatorState = createParserOperatorState(solver.program.operators.values(), false);
      const clauses = parseClauses(convertedTermText(candidate.text, solver), {
        sourceMetadata: false,
        operatorState,
      });
      if (clauses.length !== 1 || clauses[0].body.length) throw new Error('bad term');
      stream.position = candidate.end;
      return clauses[0].head;
    } catch (_) {
      // A dot inside a graphic operator, such as =.., is only a possible
      // terminator. Keep scanning until a complete term parses.
    }
  }
  stream.position = String(stream.content).length;
  if (!sawCandidate) return atom('end_of_file');
  throw new PrologError('syntax_error(read_term)');
}
function* readBuiltin({ solver, goal, env }) {
  const stream = inputStreamFor(solver, goal, env);
  if (stream.type !== 'text') throw new PrologError('permission_error(input, binary_stream)', streamHandle(stream.id));
  const next = env.clone();
  if (unify(goal.args[goal.arity - 1], readTermFromStream(stream, solver), next)) yield next;
}
function* readTermBuiltin({ solver, goal, env }) {
  const stream = goal.arity === 2 ? solver.io.resolve(solver.io.currentInput) : requireStream(solver, goal.args[0], env, 'read');
  if (stream.type !== 'text') throw new PrologError('permission_error(input, binary_stream)', streamHandle(stream.id));
  const options = optionList(goal.args[goal.arity - 1], env);
  const target = goal.args[goal.arity - 2];
  const term = readTermFromStream(stream, solver);
  const next = env.clone();
  if (!unify(target, term, next)) return;
  const variables = [];
  const counts = new Map();
  const visit = (item) => {
    if (item.type === VAR) {
      counts.set(item.name, (counts.get(item.name) ?? 0) + 1);
      if (!variables.some((entry) => entry.name === item.name)) variables.push(item);
    } else for (const arg of item.args) visit(arg);
  };
  visit(term);
  for (const option of options) {
    if (option.type !== COMPOUND || option.arity !== 1) throw new PrologError('domain_error(read_option)', option);
    let value;
    if (option.name === 'variables') {
      value = listFromItems(variables);
    } else if (option.name === 'variable_names') {
      value = listFromItems(variables
        .filter((item) => !item.name.startsWith('__anon'))
        .map((item) => compound('=', [atom(item.name), item])));
    } else if (option.name === 'singletons') {
      value = listFromItems(variables
        .filter((item) => !item.name.startsWith('__anon') && counts.get(item.name) === 1)
        .map((item) => compound('=', [atom(item.name), item])));
    } else {
      throw new PrologError('domain_error(read_option)', option);
    }
    if (!unify(option.args[0], value, next)) return;
  }
  yield next;
}
function defaultTermWriteOptions(mode) {
  if (mode === 'writeq') return { quoted: true, ignoreOps: false, numbervars: true, variableNames: new Map() };
  if (mode === 'canonical') return { quoted: true, ignoreOps: true, numbervars: false, variableNames: new Map() };
  return { quoted: false, ignoreOps: false, numbervars: true, variableNames: new Map() };
}

function writeOptionBoolean(value, env, option) {
  value = deref(value, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  if (value.type !== ATOM || !['true', 'false'].includes(value.name)) {
    throw new PrologError('domain_error(write_option)', option);
  }
  return value.name === 'true';
}

function writeVariableNames(value, env, option) {
  value = deref(value, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  const items = properListItems(value, env);
  if (items == null) {
    if (isPartialList(value, env)) throw new PrologError('instantiation_error');
    throw new PrologError('domain_error(write_option)', option);
  }
  const names = new Map();
  for (const item of items) {
    const pair = deref(item, env);
    if (pair.type !== COMPOUND || pair.name !== '=' || pair.arity !== 2) {
      throw new PrologError('domain_error(write_option)', option);
    }
    const name = deref(pair.args[0], env);
    const target = pair.args[1];
    if (name.type === VAR) throw new PrologError('instantiation_error');
    if (name.type !== ATOM || target.type !== VAR) {
      throw new PrologError('domain_error(write_option)', option);
    }
    names.set(target.name, name.name);
  }
  return names;
}

function termWriteOptions(term, env, mode = 'write') {
  const result = defaultTermWriteOptions(mode);
  for (const option of optionList(term, env)) {
    if (option.type !== COMPOUND || option.arity !== 1) {
      throw new PrologError('domain_error(write_option)', option);
    }
    if (option.name === 'quoted') result.quoted = writeOptionBoolean(option.args[0], env, option);
    else if (option.name === 'ignore_ops') result.ignoreOps = writeOptionBoolean(option.args[0], env, option);
    else if (option.name === 'numbervars') result.numbervars = writeOptionBoolean(option.args[0], env, option);
    else if (option.name === 'variable_names') result.variableNames = writeVariableNames(option.args[0], env, option);
    else throw new PrologError('domain_error(write_option)', option);
  }
  return result;
}

function writeBuiltin(mode) {
  return function* ({ solver, goal, env }) {
    const stream = outputStreamFor(solver, goal, env);
    if (stream.type !== 'text') throw new PrologError('permission_error(output, binary_stream)', streamHandle(stream.id));
    const options = defaultTermWriteOptions(mode);
    solver.io.writeUnit(stream, formatTermForWrite(goal.args[goal.arity - 1], env, {
      ...options,
      operators: solver.program.operators.values(),
    }));
    yield env;
  };
}
function* writeTermBuiltin({ solver, goal, env }) {
  const stream = goal.arity === 2 ? solver.io.resolve(solver.io.currentOutput) : requireStream(solver, goal.args[0], env, 'write');
  if (stream.type !== 'text') throw new PrologError('permission_error(output, binary_stream)', streamHandle(stream.id));
  const options = termWriteOptions(goal.args[goal.arity - 1], env);
  solver.io.writeUnit(stream, formatTermForWrite(goal.args[goal.arity - 2], env, {
    ...options,
    operators: solver.program.operators.values(),
  }));
  yield env;
}

function resolvedOrVariable(term, env, expected) {
  const value = deref(term, env);
  if (value.type !== VAR && value.type !== expected) {
    throw new PrologError(`type_error(${expected === ATOM ? 'atom' : 'number'})`, value);
  }
  return value;
}

function characters(text) {
  return Array.from(text);
}

function* atomLengthBuiltin({ goal, env }) {
  const value = deref(goal.args[0], env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  if (value.type !== ATOM) throw new PrologError('type_error(atom)', value);
  const length = deref(goal.args[1], env);
  if (length.type !== VAR && (length.type !== NUMBER || !isDecimalInteger(length.name))) {
    throw new PrologError('type_error(integer)', length);
  }
  if (length.type === NUMBER && BigInt(length.name) < 0n) {
    throw new PrologError('domain_error(not_less_than_zero)', length);
  }
  const next = env.clone();
  if (unify(goal.args[1], numberTerm(characters(value.name).length), next)) yield next;
}

function* atomConcatBuiltin({ goal, env }) {
  const first = resolvedOrVariable(goal.args[0], env, ATOM);
  const second = resolvedOrVariable(goal.args[1], env, ATOM);
  const whole = resolvedOrVariable(goal.args[2], env, ATOM);
  if (first.type === VAR && whole.type === VAR) throw new PrologError('instantiation_error');
  if (second.type === VAR && whole.type === VAR) throw new PrologError('instantiation_error');

  const candidates = [];
  if (whole.type === ATOM && first.type === VAR && second.type === VAR) {
    const chars = characters(whole.name);
    for (let i = 0; i <= chars.length; i++) candidates.push([chars.slice(0, i).join(''), chars.slice(i).join(''), whole.name]);
  } else if (first.type === ATOM && second.type === ATOM) {
    candidates.push([first.name, second.name, first.name + second.name]);
  } else if (first.type === ATOM && whole.type === ATOM && whole.name.startsWith(first.name)) {
    candidates.push([first.name, whole.name.slice(first.name.length), whole.name]);
  } else if (second.type === ATOM && whole.type === ATOM && whole.name.endsWith(second.name)) {
    candidates.push([whole.name.slice(0, whole.name.length - second.name.length), second.name, whole.name]);
  }
  for (const [a, b, c] of candidates) {
    const next = env.clone();
    if (unify(goal.args[0], atom(a), next) && unify(goal.args[1], atom(b), next) &&
        unify(goal.args[2], atom(c), next)) yield next;
  }
}

function optionalNonNegativeInteger(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) return null;
  if (value.type !== NUMBER || !isDecimalInteger(value.name)) throw new PrologError('type_error(integer)', value);
  const integer = BigInt(value.name);
  if (integer < 0n) throw new PrologError('domain_error(not_less_than_zero)', value);
  return integer;
}

function* subAtomBuiltin({ goal, env }) {
  const source = deref(goal.args[0], env);
  if (source.type === VAR) throw new PrologError('instantiation_error');
  if (source.type !== ATOM) throw new PrologError('type_error(atom)', source);
  const sub = resolvedOrVariable(goal.args[4], env, ATOM);
  const before = optionalNonNegativeInteger(goal.args[1], env);
  const length = optionalNonNegativeInteger(goal.args[2], env);
  const after = optionalNonNegativeInteger(goal.args[3], env);
  const chars = characters(source.name);
  for (let start = 0; start <= chars.length; start++) {
    if (before != null && before !== BigInt(start)) continue;
    for (let size = 0; size <= chars.length - start; size++) {
      const remaining = chars.length - start - size;
      if (length != null && length !== BigInt(size)) continue;
      if (after != null && after !== BigInt(remaining)) continue;
      const text = chars.slice(start, start + size).join('');
      if (sub.type === ATOM && sub.name !== text) continue;
      const next = env.clone();
      if (unify(goal.args[1], numberTerm(start), next) &&
          unify(goal.args[2], numberTerm(size), next) &&
          unify(goal.args[3], numberTerm(remaining), next) &&
          unify(goal.args[4], atom(text), next)) yield next;
    }
  }
}

function listElements(term, env) {
  const items = [];
  let cursor = deref(term, env);
  while (cursor.type === COMPOUND && cursor.name === '.' && cursor.arity === 2) {
    items.push(deref(cursor.args[0], env));
    cursor = deref(cursor.args[1], env);
  }
  return { items, tail: cursor };
}

function oneChar(value) {
  return value.type === ATOM && characters(value.name).length === 1;
}

function validCharacterCode(value) {
  if (value.type !== NUMBER || !isDecimalInteger(value.name)) return false;
  const code = BigInt(value.name);
  return code >= 0n && code <= 0x10ffffn && !(code >= 0xd800n && code <= 0xdfffn);
}

function listToAtomInput(list, env, kind) {
  const { items, tail } = listElements(list, env);
  if (tail.type === VAR || items.some((item) => item.type === VAR)) throw new PrologError('instantiation_error');
  if (tail.type !== ATOM || tail.name !== '[]') throw new PrologError('type_error(list)', tail);
  if (kind === 'chars') {
    const invalid = items.find((item) => !oneChar(item));
    if (invalid) throw new PrologError('type_error(character)', invalid);
    return items.map((item) => item.name).join('');
  }
  const nonInteger = items.find((item) => item.type !== NUMBER || !isDecimalInteger(item.name));
  if (nonInteger) throw new PrologError('type_error(integer)', nonInteger);
  const invalid = items.find((item) => !validCharacterCode(item));
  if (invalid) throw new PrologError('representation_error(character_code)');
  return items.map((item) => String.fromCodePoint(Number(item.name))).join('');
}

function atomListBuiltin(kind) {
  return function* ({ goal, env }) {
    const value = deref(goal.args[0], env);
    if (value.type !== VAR && value.type !== ATOM) throw new PrologError('type_error(atom)', value);
    const list = deref(goal.args[1], env);
    if (value.type === VAR && list.type === VAR) throw new PrologError('instantiation_error');
    const next = env.clone();
    if (value.type === ATOM) {
      const { items: supplied, tail } = listElements(list, env);
      if (tail.type !== VAR && !(tail.type === ATOM && tail.name === '[]')) {
        throw new PrologError('type_error(list)', list);
      }
      const invalid = supplied.find((item) => item.type !== VAR &&
        (kind === 'chars' ? !oneChar(item) :
          item.type !== NUMBER || !isDecimalInteger(item.name) || !validCharacterCode(item)));
      if (invalid) {
        if (kind === 'chars') throw new PrologError('type_error(character)', invalid);
        if (invalid.type !== NUMBER || !isDecimalInteger(invalid.name)) {
          throw new PrologError('type_error(integer)', invalid);
        }
        throw new PrologError('representation_error(character_code)');
      }
      const items = characters(value.name).map((ch) =>
        kind === 'chars' ? atom(ch) : numberTerm(ch.codePointAt(0)));
      if (unify(goal.args[1], listFromItems(items), next)) yield next;
      return;
    }
    if (unify(goal.args[0], atom(listToAtomInput(list, env, kind)), next)) yield next;
  };
}
const atomCharsBuiltin = atomListBuiltin('chars');
const atomCodesBuiltin = atomListBuiltin('codes');

function* charCodeBuiltin({ goal, env }) {
  const char = deref(goal.args[0], env);
  const code = deref(goal.args[1], env);
  if (char.type === VAR && code.type === VAR) throw new PrologError('instantiation_error');
  if (char.type !== VAR && !oneChar(char)) throw new PrologError('type_error(character)', char);
  if (code.type !== VAR && (code.type !== NUMBER || !isDecimalInteger(code.name))) {
    throw new PrologError('type_error(integer)', code);
  }
  if (code.type !== VAR && !validCharacterCode(code)) throw new PrologError('representation_error(character_code)');
  const next = env.clone();
  if (char.type === ATOM) {
    if (unify(goal.args[1], numberTerm(char.name.codePointAt(0)), next)) yield next;
  } else if (unify(goal.args[0], atom(String.fromCodePoint(Number(code.name))), next)) yield next;
}

function parseIsoNumber(text) {
  const trimmed = text.replace(/^[\u0009-\u000d\u0020]+/, '');
  if (!/^[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$/.test(trimmed)) return null;
  if (/^[+-]?\d+$/.test(trimmed)) return numberTerm(BigInt(trimmed).toString());
  const value = Number(trimmed);
  return Number.isFinite(value) ? numberTerm(numberTextFromDouble(value)) : null;
}

function numberListBuiltin(kind) {
  return function* ({ goal, env }) {
    const value = deref(goal.args[0], env);
    if (value.type !== VAR && value.type !== NUMBER) throw new PrologError('type_error(number)', value);
    const list = deref(goal.args[1], env);
    if (value.type === VAR && list.type === VAR) throw new PrologError('instantiation_error');
    const next = env.clone();
    if (value.type === NUMBER) {
      const items = characters(value.name).map((ch) =>
        kind === 'chars' ? atom(ch) : numberTerm(ch.codePointAt(0)));
      if (unify(goal.args[1], listFromItems(items), next)) yield next;
      return;
    }
    const parsed = parseIsoNumber(listToAtomInput(list, env, kind));
    if (parsed == null) throw new PrologError('syntax_error(number)');
    if (unify(goal.args[0], parsed, next)) yield next;
  };
}
const numberCharsBuiltin = numberListBuiltin('chars');
const numberCodesBuiltin = numberListBuiltin('codes');

function* findallBuiltin({ solver, goal, env }) {
  const [template, innerGoal, bag] = goal.args;
  assertListOrPartial(bag, env);
  const collector = solver.cloneForInnerGoal(10000000);
  const collected = [];
  for (const answerEnv of collector.solve([callable(innerGoal, env)], env.clone(), 0)) {
    collected.push(freshCopy(template, answerEnv));
  }
  solver.absorbStatsFrom(collector);
  const next = env.clone();
  if (unify(bag, listFromItems(collected), next)) yield next;
}

function collectVariableNames(term, env, names = new Set()) {
  term = deref(term, env);
  if (term.type === VAR) {
    names.add(term.name);
  } else {
    for (const arg of term.args) collectVariableNames(arg, env, names);
  }
  return names;
}

function bagGoalParts(term, env) {
  const quantified = new Set();
  let iterated = deref(term, env);
  while (iterated.type === COMPOUND && iterated.name === '^' && iterated.arity === 2) {
    collectVariableNames(iterated.args[0], env, quantified);
    iterated = deref(iterated.args[1], env);
  }
  return { iterated: callable(iterated, env), quantified };
}

function assertListOrPartial(term, env) {
  if (properListItems(term, env) != null || isPartialList(term, env)) return;
  throw new PrologError('type_error(list)', deref(term, env));
}

function freeVariables(goal, template, quantified, env) {
  const templateNames = collectVariableNames(template, env);
  const goalNames = collectVariableNames(goal, env);
  return [...goalNames]
    .filter((name) => !templateNames.has(name) && !quantified.has(name))
    .map(variable);
}

function sameWitness(left, right) {
  return variantTerms(left, new Env(), right, new Env());
}

function sortedUnique(items) {
  const sorted = [...items].sort(compareTerms);
  return sorted.filter((item, index) => index === 0 || compareTerms(sorted[index - 1], item) !== 0);
}

function allSolutionsBuiltin(asSet) {
  return function* ({ solver, goal, env }) {
    assertListOrPartial(goal.args[2], env);
    const { iterated, quantified } = bagGoalParts(goal.args[1], env);
    const free = freeVariables(iterated, goal.args[0], quantified, env);
    const collector = solver.cloneForInnerGoal(10000000);
    const groups = [];
    for (const answerEnv of collector.solve([iterated], env.clone(), 0)) {
      const copied = freshCopy(compound('$bag', [
        compound('$witness', free),
        goal.args[0],
      ]), answerEnv);
      let group = groups.find((candidate) => sameWitness(candidate.witness, copied.args[0]));
      if (!group) {
        group = { witness: copied.args[0], templates: [] };
        groups.push(group);
        group.templates.push(copied.args[1]);
      } else {
        const alignment = new Env();
        unify(copied.args[0], group.witness, alignment);
        group.templates.push(copyResolved(copied.args[1], alignment));
      }
    }
    solver.absorbStatsFrom(collector);
    for (const group of groups) {
      const next = env.clone();
      let matches = true;
      for (let i = 0; i < free.length; i++) {
        if (!unify(free[i], group.witness.args[i], next)) { matches = false; break; }
      }
      const templates = asSet ? sortedUnique(group.templates) : group.templates;
      if (matches && unify(goal.args[2], listFromItems(templates), next)) yield next;
    }
  };
}
const bagofBuiltin = allSolutionsBuiltin(false);
const setofBuiltin = allSolutionsBuiltin(true);

function callable(term, env) {
  term = resolveCallable(term, env);
  if (term.type === VAR) throw new PrologError('instantiation_error');
  if (term.type !== ATOM && term.type !== COMPOUND) throw new PrologError('type_error(callable)', term);
  return term;
}
function resolveCallable(term, env) {
  const resolved = deref(term, env);
  if (resolved.type !== COMPOUND) return resolved;
  return compound(resolved.name, resolved.args.map((arg) => resolveCallable(arg, env)));
}
function* callBuiltin({ solver, goal, env }) {
  const child = solver.cloneForInnerGoal();
  try {
    yield* child.solve([callable(goal.args[0], env)], env, 0);
  } finally {
    solver.absorbStatsFrom(child);
  }
}
function formalErrorTerm(error) {
  const parse = (text) => {
    const open = text.indexOf('(');
    if (open === -1) return atom(text);
    const name = text.slice(0, open);
    const inner = text.slice(open + 1, -1);
    const args = [];
    let start = 0;
    let depth = 0;
    for (let i = 0; i <= inner.length; i++) {
      const ch = inner[i];
      if (ch === '(') depth++;
      else if (ch === ')') depth--;
      else if ((ch === ',' || i === inner.length) && depth === 0) {
        args.push(parse(inner.slice(start, i).trim()));
        start = i + 1;
      }
    }
    return compound(name, args);
  };
  let formal = parse(error.formal);
  if (error.culprit != null && formal.type === COMPOUND) {
    formal = compound(formal.name, [...formal.args, error.culprit]);
  }
  return compound('error', [formal, atom('eyelang')]);
}
function* catchBuiltin({ solver, goal, env }) {
  const protectedGoal = callable(goal.args[0], env);
  const child = solver.cloneForInnerGoal();
  try {
    yield* child.solve([protectedGoal], env.clone(), 0);
  } catch (error) {
    const ball = error instanceof ThrownTerm
      ? error.term
      : error instanceof PrologError
        ? formalErrorTerm(error)
        : null;
    if (ball == null) throw error;
    const recovered = env.clone();
    if (!unify(goal.args[1], ball, recovered)) throw error;
    yield* solver.solve([callable(goal.args[2], recovered)], recovered, 0);
  } finally {
    solver.absorbStatsFrom(child);
  }
}
function* throwBuiltin({ goal, env }) {
  const ball = deref(goal.args[0], env);
  if (ball.type === VAR) throw new PrologError('instantiation_error');
  throw new ThrownTerm(copyResolved(ball, env));
}
function* onceBuiltin({ solver, goal, env }) {
  const child = solver.cloneForInnerGoal(1);
  for (const answer of child.solve([callable(goal.args[0], env)], env.clone(), 0)) {
    solver.absorbStatsFrom(child);
    yield answer;
    return;
  }
  solver.absorbStatsFrom(child);
}
function* repeatBuiltin({ env }) {
  while (true) yield env;
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
    for (const consequentEnv of solver.solve([callable(goal.args[1], conditionEnv)], conditionEnv, 0)) {
      // The consequent is an internal part of the current solution, not a
      // completed top-level solution. Keep a surrounding bounded search (for
      // example nested ISO once-as-if-then) from consuming its limit early.
      if (solver.solutionsSeen > 0) solver.solutionsSeen--;
      yield consequentEnv;
    }
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
  if (arity === 1 && name === '\\') {
    if (!args[0].integer) throw new PrologError('type_error(integer)', numericTerm(args[0]));
    return { integer: true, value: ~args[0].value };
  }
  if (arity === 1 && ['abs', 'sign', 'float', 'truncate', 'round', 'ceiling', 'floor',
    'float_integer_part', 'float_fractional_part',
    'sin', 'cos', 'atan', 'exp', 'log', 'sqrt'].includes(name)) {
    const a = Number(args[0].value);
    if (name === 'abs' && args[0].integer) return { integer: true, value: args[0].value < 0n ? -args[0].value : args[0].value };
    if (name === 'sign' && args[0].integer) return { integer: true, value: args[0].value < 0n ? -1n : args[0].value > 0n ? 1n : 0n };
    if (name === 'truncate' || name === 'round' || name === 'ceiling' || name === 'floor') {
      const fn = name === 'truncate' ? Math.trunc : name === 'round' ? Math.round : name === 'ceiling' ? Math.ceil : Math.floor;
      return { integer: true, value: BigInt(fn(a)) };
    }
    if (name === 'float_integer_part' || name === 'float_fractional_part') {
      if (args[0].integer) throw new PrologError('type_error(float)', numericTerm(args[0]));
      const value = name === 'float_integer_part' ? Math.trunc(a) : a - Math.trunc(a);
      return { integer: false, value };
    }
    const fn = name === 'float' ? (x) => x : name === 'abs' ? Math.abs : name === 'sign' ? Math.sign : Math[name];
    const value = fn(a);
    if (!Number.isFinite(value)) throw new PrologError('evaluation_error(undefined)');
    return { integer: false, value };
  }
  if (arity !== 2) throw new PrologError('type_error(evaluable)', compound('/', [atom(name), numberTerm(arity)]));
  const bothInteger = args[0].integer && args[1].integer;
  const a = args[0].value, b = args[1].value;
  if (['//', 'div', 'mod', 'rem', '/\\', '\\/', '<<', '>>'].includes(name) && !bothInteger) {
    const invalid = !args[0].integer ? args[0] : args[1];
    throw new PrologError('type_error(integer)', numericTerm(invalid));
  }
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
  else throw new PrologError('type_error(evaluable)', compound('/', [atom(name), numberTerm(arity)]));
  if (!Number.isFinite(value)) throw new PrologError('evaluation_error(undefined)');
  return { integer: false, value };
}
export function arithmeticValueTerm(value) {
  return value.integer ? numberTerm(value.value.toString()) : numberTerm(numberTextFromDouble(value.value));
}
function numericTerm(value) {
  return arithmeticValueTerm(value);
}
export function evaluateArithmetic(term, env) {
  return evaluate(term, env);
}
export function compareArithmeticValues(left, right) {
  const a = left.value;
  const b = right.value;
  return left.integer && right.integer
    ? (a < b ? -1 : a > b ? 1 : 0)
    : (Number(a) < Number(b) ? -1 : Number(a) > Number(b) ? 1 : 0);
}
function* isBuiltin({ goal, env }) {
  const result = arithmeticValueTerm(evaluateArithmetic(goal.args[1], env));
  const next = env.clone();
  if (unify(goal.args[0], result, next)) yield next;
}
function arithmeticComparison(test) {
  return function* ({ goal, env }) {
    const left = evaluateArithmetic(goal.args[0], env);
    const right = evaluateArithmetic(goal.args[1], env);
    const cmp = compareArithmeticValues(left, right);
    if (test(cmp)) yield env;
  };
}


export class BuiltinRegistry {
  constructor() {
    this.defs = new Map();
  }

  add(name, arity, handler, options = {}) {
    this.defs.set(`${name}/${arity}`, {
      name,
      arity,
      handler,
      deterministic: options.deterministic ?? false,
      ready: options.ready ?? null,
      fallbackWhenNotReady: options.fallbackWhenNotReady ?? false,
      shouldUse: options.shouldUse ?? null,
      eyeLangLibrary: options.eyeLangLibrary ?? false,
    });
    return this;
  }

  get(name, arity) {
    return this.defs.get(`${name}/${arity}`) ?? null;
  }
}

export function createDefaultRegistry() {
  const registry = new BuiltinRegistry();
  isoBuiltins.register(registry);
  return registry;
}

let defaultRegistry = null;

export function getDefaultRegistry() {
  if (defaultRegistry == null) defaultRegistry = createDefaultRegistry();
  return defaultRegistry;
}
