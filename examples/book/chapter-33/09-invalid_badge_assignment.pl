% From The Art of Eyelang, Chapter 33 — Pattern 9: Integrity before inference.
invalid_badge_assignment(Badge, PersonA, PersonB) :-
  assigned_badge(PersonA, Badge),
  assigned_badge(PersonB, Badge),
  (PersonA \= PersonB).
