% From The Art of WebEntail, Chapter 23.
adult(Person) :-
  recorded_age(Person, Age),
  (Age >= 18).
