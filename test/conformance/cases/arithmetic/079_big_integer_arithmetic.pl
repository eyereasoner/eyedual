% Reference 9.2: integer arithmetic keeps exact BigInt paths where possible.
%% goal: answer(X0, X1)

answer(add_big, X) :- (X is 9007199254740993 + 7).
answer(sub_big, X) :- (X is 9007199254741000 - 7).
answer(mul_big, X) :- (X is 123456789 * 987654321).
answer(pow_big, X) :- (X is 2 ** 63).
answer(div_big, X) :- (X is 9223372036854775808 / 2).
answer(mod_big, X) :- (X is 9223372036854775809 mod 10).
