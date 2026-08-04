% From The Art of EyeDual, Chapter 32.
eligible(Person) :-
  age(Person, Age),
  (Age >= 18).
