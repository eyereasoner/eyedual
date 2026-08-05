% From The Art of EyeLang, Chapter 12.
invalid_probability(Disease, Probability) :-
  probability(Disease, Probability),
  (Probability > 1).
