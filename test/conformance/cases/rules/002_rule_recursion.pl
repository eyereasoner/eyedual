% Reference 6, 7: definite clauses, conjunction, and recursive proof search.
%% goal: ancestor(X0, X1)

parent(pat, jan).
parent(jan, emma).
ancestor_any(X, Y) :- parent(X, Y).
ancestor_any(X, Z) :- parent(X, Y), ancestor_any(Y, Z).
ancestor(pat, Y) :- ancestor_any(pat, Y).
