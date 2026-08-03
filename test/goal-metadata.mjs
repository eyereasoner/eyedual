// Test-only metadata. `% goal:` comments keep fixture programs valid ISO text
// while letting batch tests choose the externally supplied goals they execute.
export function goalsFromSource(source) {
  const goals = [];
  const lines = source.split(/\r?\n/);
  for (let index = 0; index < lines.length; index++) {
    const match = lines[index].match(/^\s*%%\s*goal:\s*(.*)$/);
    if (!match) continue;
    let goal = match[1];
    while (lines[index + 1]?.match(/^\s*%%/) && !lines[index + 1].match(/^\s*%%\s*goal:/)) {
      index++;
      goal += `\n${lines[index].replace(/^\s*%%\s?/, '')}`;
    }
    goals.push(goal.trim());
  }
  return goals;
}

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
import { parseGoalText } from '../src/parser.js';
