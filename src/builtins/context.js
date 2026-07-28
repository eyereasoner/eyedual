// Native accelerators for the portable comma-context relations.
import { atom, deref, isConjunction, listFromItems, unify } from '../term.js';

export const contextBuiltins = {
  register(registry) {
    registry.add('holds', 2, holdsTerm, { portableEquivalent: true });
    registry.add('holds', 3, holdsParts, { portableEquivalent: true });
  }
};

function* contextTerms(context, env) {
  context = deref(context, env);
  if (isConjunction(context)) {
    yield* contextTerms(context.args[0], env);
    yield* contextTerms(context.args[1], env);
  } else {
    yield context;
  }
}

function* holdsTerm({ goal, env }) {
  for (const term of contextTerms(goal.args[0], env)) {
    const next = env.clone();
    if (unify(goal.args[1], term, next)) yield next;
  }
}

function* holdsParts({ goal, env }) {
  for (const term of contextTerms(goal.args[0], env)) {
    if (term.type !== 'atom' && term.type !== 'compound') continue;
    const next = env.clone();
    const args = listFromItems(term.type === 'compound' ? term.args : []);
    if (unify(goal.args[1], atom(term.name), next) && unify(goal.args[2], args, next)) yield next;
  }
}
