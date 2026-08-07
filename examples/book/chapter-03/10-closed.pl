% From The Art of EyeProlog, Chapter 3 — Meaning is not the search strategy.
closed(X) :- blocked(X).
open(X) :- candidate(X), \+ closed(X).
