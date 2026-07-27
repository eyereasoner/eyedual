// Public JavaScript API surface for embedders and the browser playground.
// The CLI imports the same parser, program, solver, and term primitives from here.
export { Program, makeProgram } from './program.js';
export { parseClauses, parseProgramText } from './parser.js';
export { Solver } from './solver.js';
export { INFERENCE_FUSE_EXIT_CODE, InferenceFuseError, checkInferenceFuses, formatInferenceFuse } from './fuse.js';
export * from './term.js';
export {
  BuiltinRegistry,
  createDefaultRegistry,
  createLibraryRegistry,
  getDefaultRegistry,
  getLibraryRegistry,
} from './builtins/registry.js';
export { PrologError } from './builtins/iso.js';

import { Env, copyResolved, termIsGround, termToString } from './term.js';
import { Program } from './program.js';
import { Solver } from './solver.js';
import { whyNoProof, whyProof } from './explain.js';
import { getDefaultRegistry } from './builtins/registry.js';
import { checkInferenceFuses } from './fuse.js';

export function run(source, options = {}) {
  const includeWhy = options.proof === true || options.why === true || options.explain === true;
  const parseOptions = { ...options, sourceMetadata: includeWhy, markRecursive: includeWhy };
  const program = source instanceof Program ? source : Program.parse(source, parseOptions);
  const runOptions = options.registry ? options : { ...options, registry: getDefaultRegistry() };
  const solver = new Solver(program, runOptions);
  checkInferenceFuses(program, solver);
  const output = [];
  const goals = program.queryGoals();
  const queriedKeys = new Set(goals.map((goal) => `${goal.name}/${goal.arity}`));
  const facts = program.sourceFactLines(queriedKeys);
  const seen = new Set();
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
  return { stdout: output.join(''), stats: solver.stats };
}

function appendExplanation(output, program, resolved, registry) {
  const proof = whyProof(program, resolved, { registry });
  output.push(proof.text);
  if (!proof.ok) output.push(whyNoProof(resolved));
}

export * from './explain.js';
