% From The Art of Eyepl, Chapter 19 — Integrity is not merely failure.
false :-
  lower_limit(Name, Low),
  upper_limit(Name, High),
  (Low > High).
