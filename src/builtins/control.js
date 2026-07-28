// Native accelerators for portable control relations.
export const controlBuiltins = {
  register(registry) {
    registry.add('once', 1, onceBuiltin, { portableEquivalent: true });
  }
};

function* onceBuiltin({ solver, goal, env }) {
  const limited = solver.cloneForInnerGoal(1);
  for (const answerEnv of limited.solve([goal.args[0]], env.clone(), 0)) {
    solver.absorbStatsFrom(limited);
    yield answerEnv;
    return;
  }
  solver.absorbStatsFrom(limited);
}
