// Inference fuses are integrity constraints written as `false :- Goals.`
// They are checked before output goals and abort reasoning on the first match.
import { Env, copyResolved, termToString } from './term.js';

export const INFERENCE_FUSE_EXIT_CODE = 65;

export class InferenceFuseError extends Error {
  constructor(clause, env) {
    super('Inference fuse triggered.');
    this.name = 'InferenceFuseError';
    this.code = INFERENCE_FUSE_EXIT_CODE;
    this.clause = clause;
    this.stdout = formatInferenceFuse(clause, env);
  }
}

export function checkInferenceFuses(program, solver) {
  for (const clause of program.fuses) {
    solver.solutionsSeen = 0;
    for (const env of solver.solve(clause.body, new Env(), 0)) {
      throw new InferenceFuseError(clause, env);
    }
  }
}

export function formatInferenceFuse(clause, env = new Env()) {
  const schematic = fuseClauseToString(clause, new Env());
  const matched = fuseClauseToString(clause, env);
  const lines = [
    '% Inference fuse triggered.',
    '% Fired rule:',
    `%   ${schematic}`,
  ];
  if (matched !== schematic) {
    lines.push(
      '% Matched instance:',
      `%   ${matched}`,
    );
  }
  return `${lines.join('\n')}\n`;
}

function fuseClauseToString(clause, env) {
  if (clause.body.length === 0) return 'false.';
  const body = clause.body
    .map((goal) => termToString(copyResolved(goal, env), new Env(), true))
    .join(', ');
  return `false :- ${body}.`;
}
