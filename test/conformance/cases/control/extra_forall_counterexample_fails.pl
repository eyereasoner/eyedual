%% goal: answer(X0)

answer(forall_counterexample_fails) :- \+ bound_counterexample.
bound_counterexample :- member(X, [1, 2, 3]), \+ (X < 3).
