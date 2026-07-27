% From The Art of Eyepl, Chapter 7.
allowed(User) :-
  user(User),
  \+ blocked(User).
