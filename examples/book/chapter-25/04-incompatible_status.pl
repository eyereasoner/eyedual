% From The Art of Eyepl, Chapter 25 — Integrity before decisions.
incompatible_status(active, revoked).
incompatible_status(revoked, active).

false :-
  badge_status(Badge, Status),
  incompatible_status(Status, Other),
  badge_status(Badge, Other).
