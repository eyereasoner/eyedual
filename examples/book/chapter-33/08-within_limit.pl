% From The Art of EyeProlog, Chapter 33 — Pattern 8: Proof façade.
within_limit(Device) :-
  reading(Device, Value),
  maximum(Max),
  (Value =< Max).

status(Device, safe) :-
  within_limit(Device).
