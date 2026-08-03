% Reference 9.7: zero-based indexing can enumerate and set elements without mutating the source list.
%% goal: answer(X0, X1)

answer(index_value, pair(I, V)) :- nth0(I, [red, green, blue], V).
answer(bound_index, X) :- nth0(1, [red, green, blue], X).
answer(set_first, X) :- set_nth0(0, [red, green], blue, X).
answer(set_last, X) :- set_nth0(2, [a, b, c], z, X).
answer(index_too_large_rejected, ok) :- \+ nth0(3, [a, b, c], X).
answer(set_too_large_rejected, ok) :- \+ set_nth0(3, [a, b, c], z, X).
