% Existential-style consequence with two universal variables represented as a Herbrand term.
%% goal: answer(X0, X1, X2)

takes(alice, logic).
takes(alice, math).
answer(Student, Course, registration_of(Student, Course)) :- takes(Student, Course).
