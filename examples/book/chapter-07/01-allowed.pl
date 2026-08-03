% From The Art of WebEntail, Chapter 7.
allowed(User) :-
  user(User),
  \+ blocked(User).
