% From The Art of WebEntail, Chapter 3.
can_enter(Person) :- staff(Person).
can_enter(Person) :- visitor(Person), escorted(Person).
