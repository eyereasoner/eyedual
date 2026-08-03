% From The Art of Eyepl, Chapter 21 — Substitutions accumulate.
grandparent(X, Z) :-
  parent(X, Y),
  parent(Y, Z).
