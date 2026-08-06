% From The Art of Eyelang, Chapter 21 — Failure rewinds choices, not facts.
eligible(Person) :-
  applicant(Person),
  age(Person, Age),
  (Age >= 18),
  verified(Person).
