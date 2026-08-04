% From The Art of EyeDual, Chapter 12.
invalid_probability(Disease, Probability) :-
  probability(Disease, Probability),
  (Probability > 1).
