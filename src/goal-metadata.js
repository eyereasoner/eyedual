// Host-supplied goal metadata embedded in ordinary Prolog comments.
// The source remains valid ISO Prolog text because processors may ignore it.
export function goalsFromSource(source) {
  const goals = [];
  const lines = String(source ?? '').split(/\r?\n/);
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
