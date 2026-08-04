% From The Art of EyeDual, Chapter 25 — Closed-world choice.
in_good_standing(Person) :-
  person(Person),
  \+ suspended(Person).
