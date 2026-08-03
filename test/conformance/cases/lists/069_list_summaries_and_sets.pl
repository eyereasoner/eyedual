% Reference 9.1: list summaries accept mixed numeric values and stable duplicate removal.
%% goal: answer(X0, X1)

answer(sum_empty, X) :- sum_list([], X).
answer(sum_mixed, X) :- sum_list([1, 2.5, 3], X).
answer(min_atom_order, X) :- min_list([delta, beta, gamma], X).
answer(max_atom_order, X) :- max_list([delta, beta, gamma], X).
answer(set_terms, X) :- list_to_set([pair(a, 1), pair(a, 1), pair(b, 2), pair(a, 1)], X).
answer(min_empty_rejected, ok) :- \+ min_list([], X).
answer(max_empty_rejected, ok) :- \+ max_list([], X).
