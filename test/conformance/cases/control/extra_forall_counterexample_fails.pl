query(answer(X0)).
answer(forall_counterexample_fails) :- forall(member(X, [1, 2, 3]), (X < 3)).
