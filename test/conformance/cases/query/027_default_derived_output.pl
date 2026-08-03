% An explicit query selects the answers to print.
%% goal: ancestor(X, Y)

parent(pat, jan).
parent(jan, emma).
ancestor(X, Y) :- parent(X, Y).
ancestor(X, Z) :- parent(X, Y), ancestor(Y, Z).
