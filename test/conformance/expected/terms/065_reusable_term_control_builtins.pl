answer(functor, pair(edge, 2)).
answer(arg, b).
answer(decompose, pair(edge, [a, b])).
answer(compose, edge(a, b)).
answer(term_string, 'edge(a, [b, c])').
answer(forall, ok).
