% A direct negative self-dependency is reported as unstratified.
query(answer(X0)).
p(a) :- \+ p(a).
answer(ok).
