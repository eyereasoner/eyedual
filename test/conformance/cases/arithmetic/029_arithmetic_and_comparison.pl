% Reference 9.2, 9.3: arithmetic and comparison built-ins.
answer(sum, X) :- (X is 2 + 3).
answer(diff, X) :- (X is 7 - 4).
answer(product, X) :- (X is 6 * 7).
answer(integer_division, X) :- (X is 7 / 2).
answer(remainder, X) :- (X is 7 mod 2).
answer(power, X) :- (X is 2 ** 8).
answer(minimum, X) :- (3 =< 9 -> X = 3 ; X = 9).
answer(less_than, true) :- (3 < 9).
answer(greater_equal, true) :- (9 >= 9).
%% goal: answer(X0, X1)
