% From The Art of WebEntail, Chapter 23 — Accumulators and modes.
sum_numbers([], 0).
sum_numbers([X | Xs], Sum) :-
  sum_numbers(Xs, Rest),
  (Sum is X + Rest).
