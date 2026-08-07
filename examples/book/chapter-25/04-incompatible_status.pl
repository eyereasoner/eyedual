% From The Art of EyeProlog, Chapter 25 — Integrity before decisions.
incompatible_status(active, revoked).
incompatible_status(revoked, active).

invalid_badge_status(Badge, Status, Other) :-
  badge_status(Badge, Status),
  incompatible_status(Status, Other),
  badge_status(Badge, Other).
