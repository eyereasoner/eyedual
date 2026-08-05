% From The Art of EyeLang, Chapter 23.
adult(Person) :-
  recorded_age(Person, Age),
  (Age >= 18).
