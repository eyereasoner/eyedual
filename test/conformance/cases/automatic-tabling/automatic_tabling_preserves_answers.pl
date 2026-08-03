% Automatic tabling is a search-control strategy and does not change answers.
%% goal: path(X0, X1)

edge(a, b).
edge(b, c).
path(X, Y) :- edge(X, Y).
path(X, Z) :- edge(X, Y), path(Y, Z).
