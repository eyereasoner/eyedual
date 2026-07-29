% Isolated ISO mode-table success case.
query(answer).
answer :- functor(Term, made, 0), Term = made.
