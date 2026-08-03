%% goal: answer(X0)

p(a, b) :- \+ q(a, b).
q(a, b) :- \+ p(a, b).
answer(ok).
