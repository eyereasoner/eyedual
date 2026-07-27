// Depth-first Eyepl solver with builtin dispatch, memoization, and guarded recursion handling.
// Most semantic decisions still flow through unification; optimizations only select candidates earlier.
import { COMPOUND, Env, compound, copyResolved, flattenConjunction, freshTerm, termIsGround, termToString, unify, variantTerms } from './term.js';
import { createDefaultRegistry } from './builtins/registry.js';
import { selectClauseCandidates, selectClauseCandidatesForValues } from './program.js';

let freshCounter = 0;

export function nextFreshId() {
  return ++freshCounter;
}

export class Solver {
  constructor(program, options = {}) {
    this.program = program;
    this.registry = options.registry ?? createDefaultRegistry();
    this.maxDepth = options.maxDepth ?? 100000;
    this.solutionLimit = options.solutionLimit ?? 10000000;
    this.solutionsSeen = 0;
    this.active = [];
    this.memo = new Map();
    this.tableCoordinator = null;
    this.groundChainSuccess = new Set();
    this.stats = {
      completed_goal_lists: 0,
      solve_goals_calls: 0,
      solve_one_goal_calls: 0,
      unify_calls: 0,
      max_depth: 0,
      max_goal_count: 0,
      deterministic_builtin_successes: 0,
      deterministic_builtin_failures: 0,
      table_fixpoint_rounds: 0,
    };
  }

  cloneForInnerGoal(solutionLimit = this.solutionLimit) {
    const solver = new Solver(this.program, { registry: this.registry, maxDepth: this.maxDepth, solutionLimit });
    solver.memo = this.memo;
    solver.groundChainSuccess = this.groundChainSuccess;
    return solver;
  }

  absorbStatsFrom(child) {
    if (!child || child === this || !child.stats) return;
    for (const [key, value] of Object.entries(child.stats)) {
      if (key === 'max_depth' || key === 'max_goal_count') {
        this.stats[key] = Math.max(this.stats[key] ?? 0, value ?? 0);
      } else {
        this.stats[key] = (this.stats[key] ?? 0) + (value ?? 0);
      }
    }
  }

  *solve(goals, env = new Env(), depth = 0) {
    if (!Array.isArray(goals)) goals = [goals];

    const savedActive = this.active;
    try {
      const stack = [{ kind: 'goals', goals, env, depth, active: savedActive.slice() }];
      while (stack.length) {
      const frame = stack.pop();
      if (frame.kind === 'completeTableFixpointRound') {
        frame.entry.computing = false;
        const answerCount = frame.entry.answers.length;
        if (this.tableCoordinator?.cycleSeen && answerCount > frame.answerCountBefore) {
          scheduleTableFixpointRound(stack, this, frame);
        } else {
          for (const entry of this.tableCoordinator?.entries ?? [frame.entry]) {
            entry.computing = false;
            entry.complete = true;
          }
          this.tableCoordinator = null;
          pushMemoAnswerFrames(stack, frame.entry, frame.goal, frame.rest, frame.env, frame.depth, frame.active, this);
        }
        continue;
      }
      if (frame.kind === 'completeMemo') {
        frame.entry.computing = false;
        frame.entry.complete = true;
        continue;
      }

      goals = frame.goals;
      env = frame.env;
      depth = frame.depth;
      let active = frame.active;

      while (true) {
        this.stats.solve_goals_calls++;
        this.stats.max_depth = Math.max(this.stats.max_depth, depth);
        this.stats.max_goal_count = Math.max(this.stats.max_goal_count, goals.length);
        if (depth > this.maxDepth || this.solutionsSeen >= this.solutionLimit) break;

        if (goals.length === 0) {
          this.solutionsSeen++;
          this.stats.completed_goal_lists++;
          this.active = active;
          yield env;
          break;
        }

        const first = goals[0];
        if (first?.kind === 'releaseActive') {
          active = active.slice(0, -1);
          goals = goals.slice(1);
          continue;
        }
        if (first?.kind === 'memoStore') {
          rememberMemoAnswer(first.entry, first.goal, env);
          if (goals.length === 1) break;
          goals = goals.slice(1);
          continue;
        }

        // Eyepl normally solves left-to-right, but ready deterministic builtins can
        // be run early as pure filters. Stop at internal sentinels so rule-body
        // active guards are released before the caller's remaining goals are seen.
        const selectedIndex = selectReadyDeterministicBuiltin(goals, env, this.registry);
        const goal = goals[selectedIndex];
        const rest = selectedIndex === 0 ? goals.slice(1) : [...goals.slice(0, selectedIndex), ...goals.slice(selectedIndex + 1)];
        if (goal.type === COMPOUND && goal.name === ',' && goal.arity === 2) {
          goals = [...flattenConjunction(goal), ...rest];
          depth++;
          continue;
        }

        const callable = goal.type === COMPOUND || goal.type === 'atom';
        const def = callable ? this.registry.get(goal.name, goal.arity) : null;
        this.active = active;
        if (def && builtinIsReadyOrAuthoritative(def, this, goal, env)) {
          const nextEnvs = [];
          for (const next of def.handler({ solver: this, goal, env })) nextEnvs.push(next);
          if (def.deterministic) {
            if (nextEnvs.length) this.stats.deterministic_builtin_successes++;
            else this.stats.deterministic_builtin_failures++;
          }
          if (nextEnvs.length === 0) break;
          if (nextEnvs.length === 1) {
            goals = rest;
            env = nextEnvs[0];
            depth++;
            continue;
          }
          for (let i = nextEnvs.length - 1; i >= 0; i--) {
            stack.push({ kind: 'goals', goals: rest, env: nextEnvs[i], depth: depth + 1, active });
          }
          break;
        }

        this.stats.solve_one_goal_calls++;
        if (!callable) break;
        const group = this.program.findGroup(goal.name, goal.arity);
        if (!group) break;

        if (group.tabled) {
          const key = memoKey(goal, env, group);
          if (key.hasBound) {
            const mapKey = `${goal.name}/${goal.arity}:${key.text}`;
            let entry = this.memo.get(mapKey);
            if (!entry) {
              entry = makeMemoEntry();
              this.memo.set(mapKey, entry);
            }
            if (this.tableCoordinator) this.tableCoordinator.entries.add(entry);
            if (entry.complete) {
              pushMemoAnswerFrames(stack, entry, goal, rest, env, depth, active, this);
              break;
            }
            if (!entry.computing) {
              if (!this.tableCoordinator) {
                this.tableCoordinator = { entry, cycleSeen: false, entries: new Set([entry]) };
                scheduleTableFixpointRound(stack, this, { entry, group, goal, rest, env, depth, active });
              } else {
                entry.computing = true;
                stack.push({ kind: 'completeMemo', entry });
                pushUserGoalUncachedFrames(stack, this, group, goal, [{ kind: 'memoStore', entry, goal }, ...rest], env, depth, active);
              }
              break;
            }
            if (this.tableCoordinator && activeVariantIn(goal, env, active)) {
              this.tableCoordinator.cycleSeen = true;
            }
            pushMemoAnswerFrames(stack, entry, goal, rest, env, depth, active, this);
            break;
          }
        }

        if (!group.tabled && tryPushScalarFactRunFrames(stack, this, [goal, ...rest], env, depth, active)) break;
        pushUserGoalUncachedFrames(stack, this, group, goal, rest, env, depth, active);
        break;
      }
      }
    } finally {
      this.active = savedActive;
    }
  }

  activeVariant(goal, env) {
    return activeVariantIn(goal, env, this.active);
  }

  *solveUserGoal(goal, rest, env, depth) {
    this.stats.solve_one_goal_calls++;
    if (depth > this.maxDepth || this.solutionsSeen >= this.solutionLimit) return;
    if (goal.type !== COMPOUND && goal.type !== 'atom') return;
    const group = this.program.findGroup(goal.name, goal.arity);
    if (!group) return;
    if (group.tabled) {
      yield* this.solveMemoizedGoal(group, goal, rest, env, depth);
      return;
    }
    yield* this.solveUserGoalUncached(group, goal, rest, env, depth);
  }

  *solveMemoizedGoal(group, goal, rest, env, depth) {
    yield* this.solve([goal, ...rest], env, depth);
  }

  *solveUserGoalUncached(group, goal, rest, env, depth) {
    if (this.activeVariant(goal, env)) return;
    // Program indexes provide candidate clauses, but every candidate is still
    // freshened and unified below. The index is a performance hint, not a
    // semantic shortcut.
    const candidates = selectClauseCandidates(group, goal, env);
    for (const pass of [candidates.primary, candidates.fallback]) {
      for (const clause of pass) {
        if (clause.body.length === 0 && clause.scalarHead) {
          const next = matchScalarFact(goal, clause.head, env);
          if (!next) continue;
          this.stats.unify_calls++;
          yield* this.solve(rest, next, depth + 1);
          if (this.solutionsSeen >= this.solutionLimit) return;
          continue;
        }
        if (headCannotMatch(goal, clause.head, env)) continue;
        const id = nextFreshId();
        const freshHead = freshTerm(clause.head, id);
        const freshBody = clause.body.map((term) => freshTerm(term, id));
        const next = env.clone();
        this.stats.unify_calls++;
        if (!unify(goal, freshHead, next)) continue;
        if (freshBody.length === 0) {
          yield* this.solve(rest, next, depth + 1);
        } else {
          yield* this.solveRuleBodyThenRest(goal, env, freshBody, rest, next, depth);
        }
        if (this.solutionsSeen >= this.solutionLimit) return;
      }
    }
  }
  *solveRuleBodyThenRest(goal, goalEnv, body, rest, env, depth) {
    // Match the C engine's active-call lifetime: the active guard protects
    // expansion of the current rule body, but it must be released before
    // the caller's remaining goals are solved. Keeping the goal active
    // through rest goals over-prunes valid transitive/recursive derivations.
    this.active.push({ goal, env: goalEnv });
    for (const bodyEnv of this.solve(body, env, depth + 1)) {
      if (this.solutionsSeen > 0) this.solutionsSeen--;
      this.active.pop();
      yield* this.solve(rest, bodyEnv, depth + 1);
      this.active.push({ goal, env: goalEnv });
      if (this.solutionsSeen >= this.solutionLimit) break;
    }
    this.active.pop();
  }

}

function makeMemoEntry() {
  return { computing: false, complete: false, answers: [], answerKeys: new Set() };
}

function scheduleTableFixpointRound(stack, solver, frame) {
  solver.stats.table_fixpoint_rounds++;
  solver.tableCoordinator.cycleSeen = false;
  for (const entry of solver.tableCoordinator.entries) {
    entry.computing = false;
    entry.complete = false;
  }
  frame.entry.computing = true;
  const nextFrame = {
    kind: 'completeTableFixpointRound',
    entry: frame.entry,
    group: frame.group,
    goal: frame.goal,
    rest: frame.rest,
    env: frame.env,
    depth: frame.depth,
    active: frame.active,
    answerCountBefore: frame.entry.answers.length,
  };
  stack.push(nextFrame);
  pushUserGoalUncachedFrames(
    stack,
    solver,
    frame.group,
    frame.goal,
    [{ kind: 'memoStore', entry: frame.entry, goal: frame.goal }],
    frame.env,
    frame.depth,
    frame.active,
  );
}


function pushMemoAnswerFrames(stack, entry, goal, rest, env, depth, active, solver) {
  for (let answerIndex = entry.answers.length - 1; answerIndex >= 0; answerIndex--) {
    const answerArgs = entry.answers[answerIndex];
    const next = env.clone();
    let ok = true;
    for (let i = 0; i < goal.arity; i++) {
      solver.stats.unify_calls++;
      if (!unify(goal.args[i], answerArgs[i], next)) { ok = false; break; }
    }
    if (ok) stack.push({ kind: 'goals', goals: rest, env: next, depth: depth + 1, active });
  }
}

function pushUserGoalUncachedFrames(stack, solver, group, goal, rest, env, depth, active) {
  if (activeVariantIn(goal, env, active)) return;
  if (tryPushGroundChainFrames(stack, solver, group, goal, rest, env, depth, active)) return;
  const candidates = selectClauseCandidates(group, goal, env);
  const frames = [];
  for (const pass of [candidates.primary, candidates.fallback]) {
    for (const clause of pass) {
      if (clause.body.length === 0 && clause.scalarHead) {
        const next = matchScalarFact(goal, clause.head, env);
        if (next) {
          solver.stats.unify_calls++;
          frames.push({ kind: 'goals', goals: rest, env: next, depth: depth + 1, active });
        }
        continue;
      }
      if (headCannotMatch(goal, clause.head, env)) continue;
      const id = nextFreshId();
      const freshHead = freshTerm(clause.head, id);
      const freshBody = clause.body.map((term) => freshTerm(term, id));
      const next = env.clone();
      solver.stats.unify_calls++;
      if (!unify(goal, freshHead, next)) continue;
      if (freshBody.length === 0) {
        frames.push({ kind: 'goals', goals: rest, env: next, depth: depth + 1, active });
      } else {
        frames.push({
          kind: 'goals',
          goals: [...freshBody, { kind: 'releaseActive' }, ...rest],
          env: next,
          depth: depth + 1,
          active: [...active, { goal, env }],
        });
      }
    }
  }
  for (let i = frames.length - 1; i >= 0; i--) stack.push(frames[i]);
}



const SCALAR_FACT_RUN_FRAME_LIMIT = 100000;

function tryPushScalarFactRunFrames(stack, solver, goals, env, depth, active) {
  // Consecutive lookups into predicates that are entirely scalar ground facts
  // are common in data-heavy joins. Execute such a prefix as one iterative join
  // using local binding arrays, so intermediate fact candidates do not allocate
  // cloned Env maps.
  let runLength = 0;
  const groups = [];
  while (runLength < goals.length) {
    const goal = goals[runLength];
    if (!goal || goal.kind === 'releaseActive' || goal.kind === 'memoStore') break;
    if (goal.type !== COMPOUND) break;
    const def = solver.registry.get(goal.name, goal.arity);
    if (def) break;
    const group = solver.program.findGroup(goal.name, goal.arity);
    if (!group || group.tabled || !group.scalarFactsOnly) break;
    groups.push(group);
    runLength++;
  }
  if (runLength < 2) return false;

  const rest = goals.slice(runLength);
  const localStack = [{ index: 0, names: [], values: [], depth }];
  const frames = [];

  while (localStack.length) {
    const state = localStack.pop();
    solver.stats.max_depth = Math.max(solver.stats.max_depth, state.depth);
    if (state.index === runLength) {
      const next = env.clone();
      for (let i = 0; i < state.names.length; i++) next.bind(state.names[i], state.values[i]);
      frames.push({ kind: 'goals', goals: rest, env: next, depth: state.depth, active });
      if (frames.length > SCALAR_FACT_RUN_FRAME_LIMIT) return false;
      continue;
    }

    const goal = goals[state.index];
    if (activeMightContain(goal, active) && activeVariantIn(goal, envWithLocal(env, state.names, state.values), active)) continue;
    solver.stats.solve_one_goal_calls++;
    const candidates = selectScalarFactCandidates(groups[state.index], goal, env, state.names, state.values);
    const nextStates = [];
    for (const pass of [candidates.primary, candidates.fallback]) {
      for (const clause of pass) {
        const match = matchScalarFactLocal(goal, clause.head, env, state.names, state.values);
        if (!match) continue;
        solver.stats.unify_calls++;
        nextStates.push({ index: state.index + 1, names: match.names, values: match.values, depth: state.depth + 1 });
      }
    }
    for (let i = nextStates.length - 1; i >= 0; i--) localStack.push(nextStates[i]);
    if (solver.solutionsSeen >= solver.solutionLimit) break;
  }

  for (let i = frames.length - 1; i >= 0; i--) stack.push(frames[i]);
  return true;
}


function activeMightContain(goal, active) {
  if (active.length === 0 || goal.type !== COMPOUND) return false;
  for (const entry of active) {
    const activeGoal = entry.goal;
    if (activeGoal?.type === COMPOUND && activeGoal.name === goal.name && activeGoal.arity === goal.arity) return true;
  }
  return false;
}

function envWithLocal(env, names, values) {
  if (names.length === 0) return env;
  return {
    has(name) { return names.includes(name) || env.has(name); },
    get(name) {
      const index = names.indexOf(name);
      return index >= 0 ? values[index] : env.get(name);
    },
  };
}

function selectScalarFactCandidates(group, goal, env, names, values) {
  const positions = [];
  const boundValues = [];
  for (let i = 0; i < goal.arity; i++) {
    const arg = derefScalarMatch(goal.args[i], env, names, values);
    if (!isScalarTerm(arg)) continue;
    positions.push(i);
    boundValues.push(arg);
  }
  return selectClauseCandidatesForValues(group, positions, boundValues);
}

function matchScalarFactLocal(goal, head, env, names, values) {
  if (goal.type !== COMPOUND || head.type !== COMPOUND) return null;
  if (goal.name !== head.name || goal.arity !== head.arity) return null;

  let nextNames = names;
  let nextValues = values;
  for (let i = 0; i < goal.arity; i++) {
    const factArg = head.args[i];
    const arg = derefScalarMatch(goal.args[i], env, nextNames, nextValues);
    if (arg.type === 'var') {
      if (nextNames === names) {
        nextNames = names.slice();
        nextValues = values.slice();
      }
      nextNames.push(arg.name);
      nextValues.push(factArg);
      continue;
    }
    if (!isScalarTerm(arg) || arg.name !== factArg.name) return null;
  }
  return { names: nextNames, values: nextValues };
}

function matchScalarFact(goal, head, env) {
  // A scalar ground fact has no variables to freshen and no compound structure
  // to traverse. Match the goal arguments directly and clone only after the
  // candidate has succeeded.
  if (goal.type !== COMPOUND || head.type !== COMPOUND) return null;
  if (goal.name !== head.name || goal.arity !== head.arity) return null;

  const names = [];
  const values = [];
  for (let i = 0; i < goal.arity; i++) {
    const factArg = head.args[i];
    let arg = derefScalarMatch(goal.args[i], env, names, values);
    if (arg.type === 'var') {
      names.push(arg.name);
      values.push(factArg);
      continue;
    }
    if (!isScalarTerm(arg) || arg.name !== factArg.name) return null;
  }

  const next = env.clone();
  for (let i = 0; i < names.length; i++) next.bind(names[i], values[i]);
  return next;
}

function derefScalarMatch(term, env, names, values) {
  let current = term;
  for (let guard = 0; current?.type === 'var' && guard < 128; guard++) {
    const localIndex = names.indexOf(current.name);
    if (localIndex >= 0) current = values[localIndex];
    else if (env.has(current.name)) current = env.get(current.name);
    else break;
  }
  return current;
}

function tryPushGroundChainFrames(stack, solver, group, goal, rest, env, depth, active) {
  // Compress deterministic ground single-goal chains such as deep taxonomy
  // proofs: a(ind, n100000) -> a(ind, n99999) -> ... -> a(ind, n0).
  // This is a search-control optimization only. It fires only while each step
  // has exactly one matching clause and a single ground body goal; otherwise the
  // normal clause path below remains authoritative.
  if (!termIsGround(goal, env)) return false;

  const baseEnv = env;
  let currentGroup = group;
  let currentGoal = copyResolved(goal, env);
  let currentDepth = depth;
  const currentEnv = new Env();
  const seen = new Set();

  while (true) {
    // The compressed path is iterative and protected by `seen`, so it does not
    // consume JavaScript recursion depth the way the ordinary solver path does.
    // Keep recording the logical depth for diagnostics, but do not cut off long
    // finite taxonomy chains with the recursive maxDepth guard.
    if (solver.solutionsSeen >= solver.solutionLimit) return true;
    solver.stats.max_depth = Math.max(solver.stats.max_depth, currentDepth);
    const key = groundChainKey(currentGoal);
    if (seen.has(key)) return true;
    if (activeVariantIn(currentGoal, currentEnv, active)) return true;
    if (solver.groundChainSuccess.has(key)) {
      rememberGroundChainSuccess(solver, seen);
      stack.push({ kind: 'goals', goals: rest, env: baseEnv, depth: depth + 1, active });
      return true;
    }
    seen.add(key);

    const candidates = selectClauseCandidates(currentGroup, currentGoal, currentEnv);
    const matches = [];
    for (const pass of [candidates.primary, candidates.fallback]) {
      for (const clause of pass) {
        if (headCannotMatch(currentGoal, clause.head, currentEnv)) continue;
        const match = matchGroundClause(currentGoal, clause);
        if (match === undefined) return false;
        if (match === null) continue;
        matches.push(match);
        if (matches.length > 1) return false;
      }
    }

    if (matches.length !== 1) return false;
    const match = matches[0];
    if (match.done) {
      rememberGroundChainSuccess(solver, seen);
      stack.push({ kind: 'goals', goals: rest, env: baseEnv, depth: depth + 1, active });
      return true;
    }
    const resolvedNextGoal = match.nextGoal;
    const nextGroup = solver.program.findGroup(resolvedNextGoal.name, resolvedNextGoal.arity);
    if (!nextGroup) return false;

    currentGoal = resolvedNextGoal;
    currentGroup = nextGroup;
    currentDepth++;
  }
}




function matchGroundClause(goal, clause) {
  if (clause.head.type !== COMPOUND || goal.type !== COMPOUND) return undefined;
  if (clause.head.name !== goal.name || clause.head.arity !== goal.arity) return null;

  const names = [];
  const values = [];
  for (let i = 0; i < goal.arity; i++) {
    const headArg = clause.head.args[i];
    const goalArg = goal.args[i];
    if (headArg.type === 'var') {
      let index = names.indexOf(headArg.name);
      if (index < 0) {
        names.push(headArg.name);
        values.push(goalArg);
      } else if (!sameGroundTerm(values[index], goalArg)) {
        return null;
      }
    } else if (isScalarTerm(headArg)) {
      if (!sameGroundTerm(headArg, goalArg)) return null;
    } else {
      return undefined;
    }
  }

  if (clause.body.length === 0) return { done: true };
  if (clause.body.length !== 1) return undefined;
  const bodyGoal = clause.body[0];
  if (bodyGoal.type !== COMPOUND) return undefined;
  const args = [];
  for (const arg of bodyGoal.args) {
    if (arg.type === 'var') {
      const index = names.indexOf(arg.name);
      if (index < 0) return undefined;
      args.push(values[index]);
    } else if (isScalarTerm(arg)) {
      args.push(arg);
    } else {
      return undefined;
    }
  }
  return { nextGoal: compound(bodyGoal.name, args) };
}

function isScalarTerm(term) {
  return term && (term.type === 'atom' || term.type === 'string' || term.type === 'number');
}

function sameGroundTerm(left, right) {
  if (left?.type !== right?.type || left?.name !== right?.name) return false;
  const arity = left.args?.length ?? 0;
  if (arity !== (right.args?.length ?? 0)) return false;
  for (let i = 0; i < arity; i++) if (!sameGroundTerm(left.args[i], right.args[i])) return false;
  return true;
}

function groundChainKey(term) {
  if (term?.type === COMPOUND) {
    let out = `${term.name}/${term.arity}`;
    for (let i = 0; i < term.arity; i++) out += `${groundChainKey(term.args[i])}`;
    return out;
  }
  return `${term?.type ?? ''}:${term?.name ?? ''}`;
}

function rememberGroundChainSuccess(solver, seen) {
  for (const key of seen) solver.groundChainSuccess.add(key);
}

function rememberMemoAnswer(entry, goal, env) {
  const variables = new Map();
  const answerKeys = [];
  const answerArgs = goal.args.map((arg) => {
    const answer = copyResolvedWithKey(arg, env, variables);
    answerKeys.push(answer.key);
    return answer.term;
  });
  const key = answerKeys.join('\x1f');
  if (entry.answerKeys.has(key)) return;
  entry.answerKeys.add(key);
  entry.answers.push(answerArgs);
}

function activeVariantIn(goal, env, active) {
  return active.some((entry) => variantTerms(goal, env, entry.goal, entry.env));
}


function builtinIsReadyOrAuthoritative(def, solver, goal, env) {
  if (typeof def.shouldUse === 'function' && !def.shouldUse({ solver, goal, env })) return false;
  if (typeof def.ready !== 'function') return true;
  if (def.ready(goal, env)) return true;
  return !def.fallbackWhenNotReady;
}

function selectReadyDeterministicBuiltin(goals, env, registry) {
  for (let i = 0; i < goals.length; i++) {
    const goal = goals[i];
    if (goal?.kind === 'releaseActive' || goal?.kind === 'memoStore') return 0;
    if (goal.type !== COMPOUND && goal.type !== 'atom') continue;
    const def = registry.get(goal.name, goal.arity);
    if (!def?.deterministic || typeof def.ready !== 'function') continue;
    if (typeof def.shouldUse === 'function') continue;
    if (def.ready(goal, env)) return i;
  }
  return 0;
}

function headCannotMatch(goal, head, env) {
  if (goal.type !== COMPOUND || head.type !== COMPOUND) return false;
  if (goal.name !== head.name || goal.arity !== head.arity) return true;
  for (let i = 0; i < goal.arity; i++) {
    const a = goal.args[i];
    const b = head.args[i];
    // Keep this only as a cheap scalar rejection. unify() remains authoritative.
    const da = derefForLocal(a, env);
    if (da.args?.length === 0 && ['atom', 'string', 'number'].includes(da.type) && ['atom', 'string', 'number'].includes(b.type) && da.name !== b.name) return true;
  }
  return false;
}

function derefForLocal(term, env) {
  let current = term;
  while (current.type === 'var' && env.has(current.name)) current = env.get(current.name);
  return current;
}

function memoKey(goal, env, group = null) {
  let hasBound = false;
  const variables = new Map();
  const required = group?.tableInputPositions ?? [];
  const ground = [];
  const parts = goal.args.map((arg) => {
    const value = derefForLocal(arg, env);
    if (value.type === 'var') {
      ground.push(false);
      return '_';
    }
    const canonical = canonicalTermInfo(value, env, variables);
    ground.push(canonical.ground);
    if (canonical.ground) hasBound = true;
    return canonical.key;
  });
  if (required.length > 0) {
    hasBound = required.some((index) => ground[index]);
  }
  return { hasBound, text: parts.join('|') };
}

function canonicalTermInfo(term, env, variables) {
  const value = derefForLocal(term, env);
  if (value.type === 'var') {
    let id = variables.get(value.name);
    if (id == null) {
      id = variables.size;
      variables.set(value.name, id);
    }
    return { key: `var:${id}`, ground: false };
  }
  if (!value.args?.length) return { key: `${value.type}:${value.name}`, ground: true };
  let ground = true;
  const keys = value.args.map((arg) => {
    const child = canonicalTermInfo(arg, env, variables);
    if (!child.ground) ground = false;
    return child.key;
  });
  return { key: `${value.type}:${value.name}(${keys.join(',')})`, ground };
}

function copyResolvedWithKey(term, env, variables) {
  const value = derefForLocal(term, env);
  if (value.type === 'var') {
    let id = variables.get(value.name);
    if (id == null) {
      id = variables.size;
      variables.set(value.name, id);
    }
    return { term: termModuleCache.variable(value.name), key: `var:${id}` };
  }
  if (!value.args?.length) {
    return {
      term: new termModuleCache.Term(value.type, value.name, value.args),
      key: `${value.type}:${value.name}`,
    };
  }
  const children = value.args.map((arg) => copyResolvedWithKey(arg, env, variables));
  return {
    term: termModuleCache.compound(value.name, children.map((child) => child.term)),
    key: `${value.type}:${value.name}(${children.map((child) => child.key).join(',')})`,
  };
}

// Avoid circular import surprises in older Node loaders.
import * as termModuleCache from './term.js';
