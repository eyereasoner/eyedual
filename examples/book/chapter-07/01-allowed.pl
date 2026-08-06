% From The Art of Eyelang, Chapter 7.
allowed(User) :-
  user(User),
  \+ blocked(User).
