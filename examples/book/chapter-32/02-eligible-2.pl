% From The Art of WebEntail, Chapter 32.
eligible(Person) :-
  age(Person, Age),
  (Age >= 18).
