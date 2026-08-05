% From The Art of EyeLang, Chapter 18.
compatible_pair(A, B) :-
  person(A),
  person(B),
  (A \= B),
  \+ conflict(A, B).
