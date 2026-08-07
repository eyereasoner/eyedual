% From The Art of EyeProlog, Chapter 17.
path(X, Y) :- edge(X, Y).
path(X, Z) :- edge(X, Y), path(Y, Z).
