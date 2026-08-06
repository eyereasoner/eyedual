% From The Art of Eyelang, Chapter 23 — Accumulators and modes.
sum_numbers([], 0).
sum_numbers([X | Xs], Sum) :-
  sum_numbers(Xs, Rest),
  (Sum is X + Rest).
