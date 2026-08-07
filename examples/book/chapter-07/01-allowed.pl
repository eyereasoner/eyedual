% From The Art of EyeProlog, Chapter 7.
allowed(User) :-
  user(User),
  \+ blocked(User).
