% From The Art of EyeProlog, Chapter 3 — Quantification and visible witnesses.
has_parent(Child, parent_of(Child)) :-
  person(Child).

registration(Student, Course, registration_of(Student, Course)) :-
  takes(Student, Course).
