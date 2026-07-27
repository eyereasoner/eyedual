% Reference 9.1: forall/2 succeeds for every generated binding, including the empty generator case.
query(answer(X0, X1)).
small(1).
small(2).
large(3).
answer(all_small, ok) :- forall(small(X), (X < 3)).
answer(empty_generator, ok) :- forall(missing(X), (X < 0)).
answer(not_all_large, ok) :- \+ forall(large(X), (X < 3)).
answer(bound_outer_environment, ok) :- small(X), (X = 1), forall(small(Y), (X =< Y)).
answer(checker_can_use_generator_binding, ok) :- forall(small(X), member(X, [1, 2, 3])).
