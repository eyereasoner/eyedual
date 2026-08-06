% From The Art of Eyelang, Chapter 3.
adult(Person) :-
  age(Person, Years),
  (Years >= 18).
