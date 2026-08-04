% From The Art of EyeDual, Chapter 33 — Pattern 2: Normalize at the boundary.
source_role(person_7, "Doctor").

canonical_role(Person, clinician) :-
  source_role(Person, Text),
  lowercase(Text, "doctor").
