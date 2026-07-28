% Reference 9.1: forall/2 succeeds for every generated binding, including the empty generator case.
query(answer(X0, X1)).
small(1).
small(2).
large(3).
answer(all_small, ok) :- \+ small_counterexample.
answer(empty_generator, ok) :- \+ empty_counterexample.
answer(not_all_large, ok) :- large_counterexample.
answer(bound_outer_environment, ok) :- small(X), (X = 1), \+ smaller_than(X).
answer(checker_can_use_generator_binding, ok) :- \+ missing_small_member.
small_counterexample :- small(X), \+ (X < 3).
empty_counterexample :- missing(X), \+ (X < 0).
large_counterexample :- large(X), \+ (X < 3).
smaller_than(X) :- small(Y), \+ (X =< Y).
missing_small_member :- small(X), \+ member(X, [1, 2, 3]).
