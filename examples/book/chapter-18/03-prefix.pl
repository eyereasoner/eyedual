% From The Art of EyeLang, Chapter 18 — Invent examples before recursion.
prefix([], _).
prefix([X | Xs], [X | Ys]) :- prefix(Xs, Ys).
