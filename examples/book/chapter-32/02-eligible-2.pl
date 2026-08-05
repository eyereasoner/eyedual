% From The Art of EyeLang, Chapter 32.
eligible(Person) :-
  age(Person, Age),
  (Age >= 18).
