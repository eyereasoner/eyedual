% From The Art of EyeLang, Chapter 3.
adult(Person) :-
  age(Person, Years),
  (Years >= 18).
