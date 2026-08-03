% Reference 9.7: append/3 can enumerate proper prefix/suffix splits.
answer(split, split(A, B)) :- append(A, B, [a, b]).
%% goal: answer(X0, X1)

