query(answer(X0)).
answer(forall_builtin) :- forall(member(X, [1, 2]), (X < 3)).
