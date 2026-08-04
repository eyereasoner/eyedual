% From The Art of EyeDual, Chapter 3.
can_enter(Person) :- staff(Person).
can_enter(Person) :- visitor(Person), escorted(Person).
