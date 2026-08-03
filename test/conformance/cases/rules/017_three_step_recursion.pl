% Reference 7: recursive definite clauses can derive paths beyond one step.
link(a, b).
link(b, c).
link(c, d).
path(X, Y) :- link(X, Y).
path(X, Z) :- link(X, Y), path(Y, Z).
answer(reachable, X) :- path(a, X).
%% goal: answer(X0, X1)

