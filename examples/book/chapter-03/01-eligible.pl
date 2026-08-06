% From The Art of Eyelang, Chapter 3.
eligible(Person) :-
  age(Person, Years),
  (Years >= 18),
  registered(Person).
