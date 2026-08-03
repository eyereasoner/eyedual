% Reference 9.7: append/3 supports bound prefix and suffix use cases.
answer(prefix, X) :- append(X, [c], [a, b, c]).
answer(suffix, X) :- append([a], X, [a, b, c]).
%% goal: answer(X0, X1)

