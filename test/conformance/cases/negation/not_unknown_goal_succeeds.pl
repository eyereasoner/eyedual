% Negation succeeds when its inner goal has no solution.
query(answer(X0)).
answer(ok) :- \+ missing(fact).
