% From The Art of EyeProlog, Chapter 28 — Composition, homomorphism, and reusable laws.
preserves_combine(X, Y) :-
  combine(X, Y, XY),
  image(X, IX),
  image(Y, IY),
  image(XY, IXY),
  combine(IX, IY, CombinedImages),
  (IXY = CombinedImages).
