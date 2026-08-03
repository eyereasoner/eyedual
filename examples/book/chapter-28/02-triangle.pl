% From The Art of WebEntail, Chapter 28 — Symmetry reduces search.
triangle(A, B, C) :-
  between(1, 20, A),
  between(A, 20, B),
  between(B, 20, C),
  (Sum is A + B),
  (Sum > C).
