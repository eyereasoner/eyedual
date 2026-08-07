% From The Art of EyeProlog, Chapter 18.
compatible_pair(A, B) :-
  person(A),
  person(B),
  (A \= B),
  \+ conflict(A, B).
