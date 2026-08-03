% From The Art of WebEntail, Chapter 3.
ancestor(X, Z) :- parent(X, Y), ancestor(Y, Z).
