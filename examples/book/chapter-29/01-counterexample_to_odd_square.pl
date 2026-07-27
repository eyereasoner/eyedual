% From The Art of Eyepl, Chapter 29 — Examples suggest; proofs compel.
counterexample_to_odd_square(N) :-
  between(1, 10000, N),
  (1 is N mod 2),
  (Square is N * N),
  (Remainder is Square mod 2),
  (Remainder \= 1).

query(counterexample_to_odd_square(N)).
