% Reference 9.7: set_nth0/4 updates zero-based positions functionally.
answer(first, X) :- set_nth0(0, [a, b, c], x, X).
answer(last, X) :- set_nth0(2, [a, b, c], z, X).
%% goal: answer(X0, X1)

