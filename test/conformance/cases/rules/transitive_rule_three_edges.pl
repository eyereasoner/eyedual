%% goal: path(X0, X1)

edge(a, b).
edge(b, c).
edge(c, d).
path(X, Y) :- edge(X, Y).
path(X, Z) :- edge(X, Y), path(Y, Z).
