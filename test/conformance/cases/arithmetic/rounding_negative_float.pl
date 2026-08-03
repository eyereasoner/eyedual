%% goal: answer(X0, X1)

answer(floor, X) :- (X is floor(-1.2)).
answer(ceiling, X) :- (X is ceiling(-1.2)).
answer(trunc, X) :- (X is truncate(-1.8)).
answer(rounded, X) :- (X is round(-1.5)).
