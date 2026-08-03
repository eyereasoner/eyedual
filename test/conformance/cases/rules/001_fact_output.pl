% Reference 6, 7, 11: facts can be exposed through a queried derived predicate.
%% goal: parent(X0, X1)

base_parent(pat, jan).
parent(X, Y) :- base_parent(X, Y).
