% Reference 9.7: select/3 enumerates removals of matching occurrences.
answer(rest, X) :- select(a, [a, b, a], X).
%% goal: answer(X0, X1)

