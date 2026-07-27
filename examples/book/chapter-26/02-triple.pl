% From The Art of Eyepl, Chapter 26 — Answers are existential witnesses.
triple(A, B, C) :-
  between(1, 20, A),
  between(A, 20, B),
  between(B, 20, C),
  (AA is A * A),
  (BB is B * B),
  (Sum is AA + BB),
  (Sum is C * C).

query(triple(A, B, C)).
