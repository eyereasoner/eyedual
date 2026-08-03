% From The Art of Eyepl, Chapter 12.
invalid_probability(Disease, Probability) :-
  probability(Disease, Probability),
  (Probability > 1).
