%% goal: answer(X0, X1)

answer(min, X) :- (3 =< 2.5 -> X = 3 ; X = 2.5).
answer(max, X) :- (3 >= 2.5 -> X = 3 ; X = 2.5).
