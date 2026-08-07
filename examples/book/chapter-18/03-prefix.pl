% From The Art of EyeProlog, Chapter 18 — Invent examples before recursion.
prefix([], _).
prefix([X | Xs], [X | Ys]) :- prefix(Xs, Ys).
