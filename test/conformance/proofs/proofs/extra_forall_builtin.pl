%% goal: answer(X0)

answer(forall_builtin) :- \+ forall_counterexample.
forall_counterexample :- member(X, [1, 2]), \+ (X < 3).
