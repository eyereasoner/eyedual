%% goal: answer(X0)

p(a) :- \+ q(a).
q(a) :- \+ p(a).
answer(a).
answer(b).
