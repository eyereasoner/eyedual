% From The Art of Eyepl, Chapter 32 — Create diagnostic relations.
candidate_debug(Person, Age) :-
  age(Person, Age).

adult_debug(Person, Age) :-
  candidate_debug(Person, Age),
  (Age >= 18).

query(candidate_debug(Person, Age)).
query(adult_debug(Person, Age)).
