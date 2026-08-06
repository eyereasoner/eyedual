% From The Art of Eyelang, Chapter 32.
eligible(Person) :-
  age(Person, Age),
  (Age >= 18).
