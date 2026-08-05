% From The Art of EyeLang, Chapter 33 — Pattern 3: Generate, constrain, describe.
chosen_pair(pair(X, Y), reason(sum_is_ten)) :-
  between(0, 10, X),
  between(X, 10, Y),
  (10 is X + Y).
