% Isolated ISO mode-table success case.
query(answer).
answer :- \+ arg(3, pair(left, right), Value).
