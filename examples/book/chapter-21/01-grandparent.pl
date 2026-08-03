% From The Art of WebEntail, Chapter 21 — Substitutions accumulate.
grandparent(X, Z) :-
  parent(X, Y),
  parent(Y, Z).
