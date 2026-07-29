% Isolated ISO mode-table success case.
query(answer).
answer :- \+ unify_with_occurs_check(X, f(X)).
