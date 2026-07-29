% Isolated ISO mode-table success case.
query(answer).
answer :- Term =.. [pair, a, b], Term = pair(a, b).
