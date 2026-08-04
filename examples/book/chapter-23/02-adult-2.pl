% From The Art of EyeDual, Chapter 23.
adult(Person) :-
  recorded_age(Person, Age),
  (Age >= 18).
