% From The Art of EyeLang, Chapter 25 — Closed-world choice.
in_good_standing(Person) :-
  person(Person),
  \+ suspended(Person).
