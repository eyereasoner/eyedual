% Isolated ISO mode-table success case.
query(answer).
answer :- functor(Term, made, 2), Term = made(left, right).
