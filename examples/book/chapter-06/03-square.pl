% From The Art of EyeLang, Chapter 6.
square(N, Square) :-
  between(1, 10, N),
  (Square is N * N).
