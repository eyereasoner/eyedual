% From The Art of Eyepl, Chapter 26 — The least model as mathematical closure.
edge(a, b).
edge(b, c).

path(X, Y) :- edge(X, Y).
path(X, Z) :- edge(X, Y), path(Y, Z).
