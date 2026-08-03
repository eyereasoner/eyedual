%% goal: answer(X0, X1)

edge(a, b).
edge(b, c).
path(X, Y) :- edge(X, Y).
path(X, Z) :- edge(X, Y), path(Y, Z).
answer(table_path_bound, X) :- path(a, X).
