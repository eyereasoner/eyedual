% Reference 3.4, 5.1, 7.1: each anonymous variable occurrence is fresh.
pair(a, one).
pair(b, two).
answer(fresh, yes) :- pair(a, _), pair(b, _).
%% goal: answer(X0, X1)

