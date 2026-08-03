% Reference 9.2: rounding built-ins have distinct behavior for positive and negative decimals.
%% goal: answer(X0, X1)

answer(floor_pos, X) :- (X is floor(3.9)).
answer(floor_neg, X) :- (X is floor(-3.1)).
answer(ceiling_pos, X) :- (X is ceiling(3.1)).
answer(ceiling_neg, X) :- (X is ceiling(-3.9)).
answer(trunc_pos, X) :- (X is truncate(3.9)).
answer(trunc_neg, X) :- (X is truncate(-3.9)).
answer(round_half_up, X) :- (X is round(2.5)).
answer(round_half_neg, X) :- (X is round(-2.5)).
