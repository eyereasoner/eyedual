% Reference 11.1: recursive predicate groups are detected automatically.
%% goal: reach(X0, X1)


edge(a, b).
edge(b, c).
edge(c, d).

reach(X, Y) :- reach_any(X, Y).
reach_any(X, Y) :- edge(X, Y).
reach_any(X, Z) :- edge(X, Y), reach_any(Y, Z).
