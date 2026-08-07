% From The Art of EyeProlog, Chapter 3.
ancestor(X, Z) :- parent(X, Y), ancestor(Y, Z).
