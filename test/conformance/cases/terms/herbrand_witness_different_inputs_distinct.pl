%% goal: answer(X0)

answer(true) :- (registration_of(alice, logic) \= registration_of(alice, math)).
