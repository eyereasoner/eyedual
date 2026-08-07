% From The Art of EyeProlog, Chapter 25 — Closed-world choice.
in_good_standing(Person) :-
  person(Person),
  \+ suspended(Person).
