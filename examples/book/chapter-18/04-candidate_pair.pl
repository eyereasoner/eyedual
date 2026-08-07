% From The Art of EyeProlog, Chapter 18 — Separate generate, test, and describe.
candidate_pair(A, B) :-
  person(A),
  person(B).

compatible_pair(A, B) :-
  candidate_pair(A, B),
  (A \= B),
  \+ conflict(A, B).

answer(pair(A, B)) :- compatible_pair(A, B).
