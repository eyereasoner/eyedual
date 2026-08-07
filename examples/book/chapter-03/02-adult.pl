% From The Art of EyeProlog, Chapter 3.
adult(Person) :-
  age(Person, Years),
  (Years >= 18).
