% Reference 9.7 and 9.8: list ordering and length built-ins are deterministic on proper lists.
%% goal: answer(X0, X1)

answer(length_empty, X) :- length([], X).
answer(length_nested, X) :- length([[a], [b, c], []], X).
answer(reverse_atoms, X) :- reverse([a, b, c], X).
answer(sort_numbers, X) :- sort([3, 1, 2, 1], X).
answer(sort_mixed_terms, X) :- sort([b, 2, a, 1, pair(a), "s"], X).
answer(reverse_empty, X) :- reverse([], X).
