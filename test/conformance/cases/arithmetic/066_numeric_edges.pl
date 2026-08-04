% Reference 9.1: reusable numeric functions preserve integer paths and define finite failure modes.
%% goal: answer(X0, X1)

answer(max_negative, X) :- (-10 >= -3 -> X = -10 ; X = -3).
answer(min_float, X) :- (2.5 =< -1.25 -> X = 2.5 ; X = -1.25).
answer(floor_negative, X) :- (X is floor(-3.1)).
answer(ceiling_negative, X) :- (X is ceiling(-3.9)).
answer(trunc_positive, X) :- (X is truncate(3.9)).
answer(sqrt_fraction, X) :- (X is sqrt(2.25)).
answer(pow_fraction, X) :- (X is 9 ** 0.5).
