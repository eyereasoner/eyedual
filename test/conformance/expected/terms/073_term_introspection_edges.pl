answer(functor_atom, pair(alpha, 0)).
answer(functor_number, pair(42, 0)).
answer(functor_char_list, pair('.', 2)).
answer(arg_nested, edge(a, b)).
answer(compose_nested, outer(inner(a), "bc")).
answer(compose_atom_empty_args, z).
answer(decompose_atom_empty_args, pair(z, [])).
answer(arg_zero_rejected, ok).
answer(arg_too_large_rejected, ok).
