%% goal: answer(X0)

edge(a, b).
edge(b, c).
reachable(X, Z) :- reachable(X, Y), edge(Y, Z).
reachable(X, Y) :- edge(X, Y).
answer(X) :- reachable(a, X).
