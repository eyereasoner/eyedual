%% goal: answer(X0)

answer(forall_bound_check) :- \+ bound_counterexample.
bound_counterexample :- member(X, [1, 2, 3]), \+ (X < 4).
