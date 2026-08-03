% Reference 9.2: scalar arithmetic functions return numeric values.
answer(neg, X) :- (X is -(5)).
answer(abs, X) :- (X is abs(-5)).
answer(rounded, X) :- (X is round(2.6)).
answer(sin_zero, X) :- (X is sin(0)).
answer(cos_zero, X) :- (X is cos(0)).
answer(log_one, X) :- (X is log(1)).
answer(float_division, X) :- (X is 7.0 / 2.0).
%% goal: answer(X0, X1)

