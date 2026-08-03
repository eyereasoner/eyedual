% From The Art of WebEntail, Chapter 33 — Pattern 4: Carry the witness.
path(X, Y, [X, Y]) :- edge(X, Y).
path(X, Z, [X | Rest]) :-
  edge(X, Y),
  path(Y, Z, Rest).
