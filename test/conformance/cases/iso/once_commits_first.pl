% Isolated ISO mode-table success case.
query(answer).
choice(first).
choice(second).
answer :- once(choice(X)), X = first.
