% From The Art of EyeProlog, Chapter 33 — Pattern 7: Fixed-point closure.
depends(X, Y) :- direct_dependency(X, Y).
depends(X, Z) :- direct_dependency(X, Y), depends(Y, Z).
