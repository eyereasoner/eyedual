% From The Art of Eyelang, Chapter 6.
square(N, Square) :-
  between(1, 10, N),
  (Square is N * N).
