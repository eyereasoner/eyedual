% From The Art of EyeLang, Chapter 21 — Substitutions accumulate.
grandparent(X, Z) :-
  parent(X, Y),
  parent(Y, Z).
