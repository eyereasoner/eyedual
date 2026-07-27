% Negation fails when its inner goal succeeds.
query(answer(X0)).
seen(a).
answer(ok) :- \+ seen(a).
