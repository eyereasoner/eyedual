% From The Art of EyeLang, Chapter 7.
allowed(User) :-
  user(User),
  \+ blocked(User).
