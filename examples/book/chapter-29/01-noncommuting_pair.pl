% From The Art of EyeProlog, Chapter 29 — One counterexample has asymmetric power.
noncommuting_pair(A, B) :-
  matrix(A),
  matrix(B),
  matrix_multiply(A, B, AB),
  matrix_multiply(B, A, BA),
  (AB \= BA).
