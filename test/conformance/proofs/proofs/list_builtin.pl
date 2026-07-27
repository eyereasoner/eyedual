% Reference 12: proof output preserves list read-back for built-in goals.
query(answer(X0)).
answer(X) :- member(X, [a, b]), (X = b).
