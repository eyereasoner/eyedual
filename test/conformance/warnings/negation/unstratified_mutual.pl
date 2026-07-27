% Warnings report unstratified negation without changing normal execution.
query(answer(X0)).
p(a) :- \+ q(a).
q(a) :- \+ p(a).
answer(ok).
