% From The Art of Eyelang, Chapter 17 — The same relation, a different computation.
adult(Person) :- person(Person), age(Person, Age), (Age >= 18).

adult(Person) :- (Age >= 18), age(Person, Age), person(Person).
