// Native accelerators for portable aggregation relations.
import {
  compareTerms, copyResolved, isDecimalInteger, lexicalValue,
  numberTerm, numberTextFromDouble, parseFiniteNumber, unify,
} from '../term.js';

export const aggregationBuiltins = {
  register(registry) {
    registry.add('countall', 2, countall, { portableEquivalent: true });
    registry.add('sumall', 3, sumall, { portableEquivalent: true });
    registry.add('aggregate_min', 5, aggregateBest(true), { portableEquivalent: true });
    registry.add('aggregate_max', 5, aggregateBest(false), { portableEquivalent: true });
  }
};

function* countall({ solver, goal, env }) {
  const collector = solver.cloneForInnerGoal(10000000);
  let count = 0;
  for (const _ of collector.solve([goal.args[0]], env.clone(), 0)) count++;
  solver.absorbStatsFrom(collector);
  const next = env.clone();
  if (unify(goal.args[1], numberTerm(count), next)) yield next;
}

function* sumall({ solver, goal, env }) {
  const collector = solver.cloneForInnerGoal(10000000);
  let integers = 0n;
  let floating = null;
  for (const answerEnv of collector.solve([goal.args[1]], env.clone(), 0)) {
    const text = lexicalValue(goal.args[0], answerEnv);
    if (text == null) return;
    if (floating == null && isDecimalInteger(text)) {
      integers += BigInt(text);
    } else {
      const value = parseFiniteNumber(text);
      if (value == null) return;
      if (floating == null) floating = Number(integers);
      floating += value;
    }
  }
  solver.absorbStatsFrom(collector);
  const result = floating == null ? integers.toString() : numberTextFromDouble(floating);
  const next = env.clone();
  if (unify(goal.args[2], numberTerm(result), next)) yield next;
}

function aggregateBest(wantMin) {
  return function* ({ solver, goal, env }) {
    const collector = solver.cloneForInnerGoal(10000000);
    let bestKey = null;
    let bestValue = null;
    for (const answerEnv of collector.solve([goal.args[2]], env.clone(), 0)) {
      const key = copyResolved(goal.args[0], answerEnv);
      if (bestKey == null || (wantMin ? compareTerms(key, bestKey) < 0 : compareTerms(key, bestKey) > 0)) {
        bestKey = key;
        bestValue = copyResolved(goal.args[1], answerEnv);
      }
    }
    solver.absorbStatsFrom(collector);
    if (bestKey == null) return;
    const next = env.clone();
    if (unify(goal.args[3], bestKey, next) && unify(goal.args[4], bestValue, next)) yield next;
  };
}
