%% goal: open(X0)

edge(a, b).
path(X, Y) :- edge(X, Y).
closed(c).
open(X) :- path(a, X), \+ closed(X).
