% From The Art of EyeProlog, Chapter 23.
adult(Person) :-
  recorded_age(Person, Age),
  (Age >= 18).
