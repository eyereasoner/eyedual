% Existential-style consequence with one universal variable represented as a Herbrand term.
%% goal: answer(X0, X1)

person(alice).
person(bob).
answer(Child, parent_of(Child)) :- person(Child).
