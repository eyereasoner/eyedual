% From The Art of Eyelang, Chapter 23.
adult(Person) :-
  recorded_age(Person, Age),
  (Age >= 18).
