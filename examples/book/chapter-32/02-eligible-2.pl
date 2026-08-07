% From The Art of EyeProlog, Chapter 32.
eligible(Person) :-
  age(Person, Age),
  (Age >= 18).
