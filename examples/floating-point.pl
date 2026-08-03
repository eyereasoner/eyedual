% Floating-point arithmetic and comparisons.
%
% Integer-only arithmetic stays exact, but decimal inputs use JavaScript numbers.
% This example keeps the calculations small and transparent so differences between
% add/sub/mul/div/pow and comparison predicates are visible.
%
% The thermostat facts provide a concrete comparison setting, while standalone
% value/2 reports exercise individual decimal operations.
%% goal: value(X0, X1)

%% goal: than(X0, X1)


% Sample facts provide a small thermostat scenario used by the comparison
% rules; separate value/2 facts below exercise standalone decimal arithmetic.
sample(roomC, 21.5).
sample(targetC, 19.25).

% Each value/2 fact is a small arithmetic check; than/2 and comfortable/2
% show that comparisons work over decimal results too.
value(sum, X) :- (X is 1.5 + 2.25).
value(difference, X) :- (X is 10.0 - 3.125).
value(product, X) :- (X is 2.5 * 4.0).
value(quotient, X) :- (X is 7.5 / 2).
value(sqrtByPower, X) :- (X is 9.0 ** 0.5).
value(mathSum, X) :- (X is 0.125 + 0.875).
value(mathProduct, X) :- (X is 6.0 * 0.5).
than(warmer, targetC) :- sample(roomC, R), sample(targetC, T), (R > T).
% Boolean-like conclusions remain ordinary atoms.
value(comfortable, true) :- sample(roomC, R), (R >= 21.0), (R =< 22.0).
