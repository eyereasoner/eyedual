% Reference 5.5: comma terms remain data outside goal position.
record((name(alice, "Alice"), knows(alice, bob))).
answer(formula, F) :- record(F).
%% goal: answer(X0, X1)

