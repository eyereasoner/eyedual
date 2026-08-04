% From The Art of EyeDual, Chapter 17.
path(X, Y) :- edge(X, Y).
path(X, Z) :- edge(X, Y), path(Y, Z).
