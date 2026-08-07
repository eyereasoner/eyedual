% From The Art of EyeProlog, Chapter 19 — Integrity is not merely failure.
invalid_limits(Name, Low, High) :-
  lower_limit(Name, Low),
  upper_limit(Name, High),
  (Low > High).
