% Reference 9.7: list summaries over valid numeric and ordered-term inputs.
%% goal: answer(X0, X1)

answer(sum_integers, X) :- sum_list([1, 2, 3, 4], X).
answer(sum_decimals, X) :- sum_list([1.5, 2.25, -0.75], X).
answer(min_terms, X) :- min_list([pair(b), pair(a), pair(c)], X).
answer(max_terms, X) :- max_list([pair(b), pair(a), pair(c)], X).
answer(set_scalars, X) :- list_to_set([b, a, b, 1, 1, "a", a], X).
