// Aggregation builtins that run a inner goal and collect, count, sum, or select the best answers.
// Each handler clones the solver so the inner goal can enumerate independently of the outer goal.
import { compareTerms, copyResolved, isDecimalInteger, lexicalValue, numberTerm, numberTextFromDouble, parseFiniteNumber, unify } from '../term.js';

export const aggregationBuiltins = {
  register(registry) {
    registry.add('countall', 2, countall);
    registry.add('sumall', 3, sumall);
    registry.add('aggregate_min', 5, aggregateBest(true));
    registry.add('aggregate_max', 5, aggregateBest(false));
  }
};

function* countall({ solver, goal, env }) {
  const [innerGoal, count] = goal.args;
  const collector = solver.cloneForInnerGoal(10000000);
  let n = 0;
  for (const _ of collector.solve([innerGoal], env.clone(), 0)) n++;
  const next = env.clone();
  if (unify(count, numberTerm(n), next)) yield next;
}

function* sumall({ solver, goal, env }) {
  const [template, innerGoal, sum] = goal.args;
  const collector = solver.cloneForInnerGoal(10000000);
  let intSum = 0n;
  let floatMode = false;
  let floatSum = 0;
  for (const answerEnv of collector.solve([innerGoal], env.clone(), 0)) {
    const text = lexicalValue(template, answerEnv);
    if (text == null) return;
    if (!floatMode && isDecimalInteger(text)) intSum += BigInt(text);
    else {
      const value = parseFiniteNumber(text);
      if (value == null) return;
      if (!floatMode) { floatSum = Number(intSum); floatMode = true; }
      floatSum += value;
    }
  }
  const result = floatMode ? numberTextFromDouble(floatSum) : intSum.toString();
  const next = env.clone();
  if (unify(sum, numberTerm(result), next)) yield next;
}

function aggregateBest(wantMin) {
  return function* ({ solver, goal, env }) {
    const [keyTemplate, valueTemplate, innerGoal, bestKey, bestValue] = goal.args;
    const collector = solver.cloneForInnerGoal(10000000);
    let has = false;
    let key = null;
    let value = null;
    for (const answerEnv of collector.solve([innerGoal], env.clone(), 0)) {
      const candidateKey = copyResolved(keyTemplate, answerEnv);
      const candidateValue = copyResolved(valueTemplate, answerEnv);
      if (!has) {
        has = true;
        key = candidateKey;
        value = candidateValue;
      } else {
        const cmp = compareTerms(candidateKey, key);
        if ((wantMin && cmp < 0) || (!wantMin && cmp > 0)) {
          key = candidateKey;
          value = candidateValue;
        }
      }
    }
    if (!has) return;
    const next = env.clone();
    if (unify(bestKey, key, next) && unify(bestValue, value, next)) yield next;
  };
}
