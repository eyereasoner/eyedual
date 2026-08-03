% From The Art of WebEntail, Chapter 32 — Follow bindings from left to right.
eligible(Person) :-
  (Age >= 18),
  age(Person, Age).
