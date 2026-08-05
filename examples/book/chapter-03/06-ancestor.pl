% From The Art of EyeLang, Chapter 3.
ancestor(X, Z) :- parent(X, Y), ancestor(Y, Z).
