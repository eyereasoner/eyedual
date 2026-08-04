% From The Art of EyeDual, Chapter 3.
adult(Person) :-
  age(Person, Years),
  (Years >= 18).
