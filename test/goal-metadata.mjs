import { parseGoalText } from '../src/parser.js';
import { goalsFromSource } from '../src/goal-metadata.js';

export { goalsFromSource };

// Goal comments are ordinary Prolog comments understood by the CLI and test runners.
// Preserve the historical batch-output order of source declarations: known
// predicate groups follow their first source occurrence, then declaration order.
export function goalsInProgramOrder(program, source) {
  const goals = goalsFromSource(source).map((text, index) => ({ text, index, goal: parseGoalText(text) }));
  const order = new Map([...program.groups.keys()].map((key, index) => [key, index]));
  return goals.sort((left, right) => {
    const leftOrder = order.get(`${left.goal.name}/${left.goal.arity}`) ?? Number.MAX_SAFE_INTEGER;
    const rightOrder = order.get(`${right.goal.name}/${right.goal.arity}`) ?? Number.MAX_SAFE_INTEGER;
    return leftOrder - rightOrder || left.index - right.index;
  }).map(({ text }) => text);
}
