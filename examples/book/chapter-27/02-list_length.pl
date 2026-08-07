% From The Art of EyeProlog, Chapter 27 — Structural induction and data design.
list_length([], 0).
list_length([_ | Tail], N) :-
  list_length(Tail, M),
  (N is M + 1).
