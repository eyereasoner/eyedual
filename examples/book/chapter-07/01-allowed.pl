% From The Art of EyeDual, Chapter 7.
allowed(User) :-
  user(User),
  \+ blocked(User).
