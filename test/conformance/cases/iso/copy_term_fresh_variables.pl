% Isolated ISO mode-table success case.
query(answer).
answer :- copy_term(pair(X, X), pair(A, B)), A = copied, B = copied, var(X).
