%% goal: answer(X0, X1, X2)

answer(eq_binds_both_sides, X, Y) :- (pair(X, b) = pair(a, Y)).
