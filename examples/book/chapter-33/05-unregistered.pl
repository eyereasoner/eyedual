% From The Art of EyeLang, Chapter 33 — Pattern 5: Bound absence.
unregistered(Person) :-
  person(Person),
  \+ registered(Person).
