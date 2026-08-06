% From The Art of Eyelang, Chapter 33 — Pattern 5: Bound absence.
unregistered(Person) :-
  person(Person),
  \+ registered(Person).
