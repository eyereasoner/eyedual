% From The Art of EyeProlog, Chapter 33 — Pattern 5: Bound absence.
unregistered(Person) :-
  person(Person),
  \+ registered(Person).
