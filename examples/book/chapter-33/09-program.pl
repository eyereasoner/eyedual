% From The Art of Eyepl, Chapter 33 — Pattern 9: Integrity before inference.
false :-
  assigned_badge(PersonA, Badge),
  assigned_badge(PersonB, Badge),
  (PersonA \= PersonB).
