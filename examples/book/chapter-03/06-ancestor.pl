% From The Art of EyeDual, Chapter 3.
ancestor(X, Z) :- parent(X, Y), ancestor(Y, Z).
