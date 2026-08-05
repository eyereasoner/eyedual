% From The Art of EyeLang, Chapter 20 — Introduce helpers that express invariants.
within_thermal_limits(Battery) :-
  temperature(Battery, T),
  temperature_limit(Max),
  (T =< Max).
