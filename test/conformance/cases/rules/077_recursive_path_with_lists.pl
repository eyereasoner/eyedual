% Reference 5.4, 7.3, 9.7: recursive path construction can carry list evidence.
%% goal: answer(X0, X1)

edge(a, b).
edge(b, c).
edge(c, d).
path(X, Y, [X, Y]) :- edge(X, Y).
path(X, Z, [X | Rest]) :- edge(X, Y), path(Y, Z, Rest).
answer(path, P) :- path(a, d, P).
answer(prefix, P) :- path(a, d, Full), take(2, Full, P).
answer(suffix, S) :- path(a, d, Full), drop(2, Full, S).
