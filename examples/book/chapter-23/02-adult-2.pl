% From The Art of Eyepl, Chapter 23.
adult(Person) :-
  recorded_age(Person, Age),
  (Age >= 18).
