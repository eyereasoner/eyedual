% From The Art of EyeProlog, Chapter 19 — Termination needs its own argument.
factorial(0, 1).
factorial(N, F) :-
  (N > 0),
  (Previous is N - 1),
  factorial(Previous, PF),
  (F is N * PF).
