% From The Art of WebEntail, Chapter 12.
invalid_probability(Disease, Probability) :-
  probability(Disease, Probability),
  (Probability > 1).
