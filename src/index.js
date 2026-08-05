// Public JavaScript API surface for embedders and the browser playground.
// The CLI imports the same parser, program, solver, and term primitives from here.
export { Program, makeProgram } from './program.js';
export { parseClauses, parseGoalText, parseProgramText } from './parser.js';
export { Solver } from './solver.js';
export * from './term.js';
export {
  BuiltinRegistry,
  createDefaultRegistry,
  getDefaultRegistry,
  HaltSignal,
  PrologError,
} from './iso.js';
export {
  createEyeLangRegistry,
  getEyeLangRegistry,
} from './library.js';
export { StreamManager } from './io.js';

import { ATOM, COMPOUND, VAR, Env, copyResolved, termIsGround, termToString } from './term.js';
import { Program } from './program.js';
import { Solver } from './solver.js';
import { whyNoProof, whyProof } from './explain.js';
import { HaltSignal, PrologError } from './iso.js';
import { getEyeLangRegistry } from './library.js';
import { parseGoalText } from './parser.js';

export function run(source, options = {}) {
  const includeWhy = options.proof === true || options.why === true || options.explain === true;
  const parseOptions = { ...options, sourceMetadata: includeWhy };
  let program = source instanceof Program ? source : Program.parse(source, parseOptions);
  const runOptions = options.registry ? options : { ...options, registry: getEyeLangRegistry() };
  const output = [];
  const solver = new Solver(program, {
    ...runOptions,
    ioOptions: {
      ...(options.ioOptions ?? {}),
      write: (text) => {
        const rendered = String(text);
        output.push(rendered);
        options.ioOptions?.write?.(rendered);
      },
    },
  });
  program = solver.program;
  const goals = normalizeGoals(options);
  const queriedKeys = new Set(goals.map((goal) => `${goal.name}/${goal.arity}`));
  const facts = program.sourceFactLines(queriedKeys);
  const seen = new Set();
  let haltCode = null;
  try {
    solver.runInitializations();
    for (const goal of goals) {
      solver.solutionsSeen = 0;
      for (const env of solver.solve([goal], new Env(), 0)) {
        const resolved = copyResolved(goal, env);
        if (!termIsGround(resolved)) continue;
        const line = `${termToString(resolved, new Env(), true)}.\n`;
        if (facts.has(line) || seen.has(line)) continue;
        seen.add(line);
        output.push(line);
        if (includeWhy) appendExplanation(output, program, resolved, runOptions.registry);
      }
    }
  } catch (error) {
    if (!(error instanceof HaltSignal)) throw error;
    haltCode = error.code;
  }
  return { stdout: output.join(''), stats: solver.stats, haltCode };
}

function normalizeGoals(options) {
  const requested = options.goals ?? (options.goal == null ? [] : [options.goal]);
  return requested.map((requestedGoal) => {
    const goal = typeof requestedGoal === 'string' ? parseGoalText(requestedGoal) : requestedGoal;
    if (goal.type === VAR) throw new PrologError('instantiation_error');
    if (goal.type !== ATOM && goal.type !== COMPOUND) throw new PrologError('type_error(callable)', goal);
    return goal;
  });
}

function appendExplanation(output, program, resolved, registry) {
  const proof = whyProof(program, resolved, { registry });
  output.push(proof.text);
  if (!proof.ok) output.push(whyNoProof(resolved));
}

export * from './explain.js';
