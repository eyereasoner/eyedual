% From The Art of WebEntail, Chapter 3.
adult(Person) :-
  age(Person, Years),
  (Years >= 18).
