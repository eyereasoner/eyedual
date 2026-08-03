%% goal: answer(X0)

p(a) :- \+ q(a).
q(a) :- \+ r(a).
r(a) :- \+ p(a).
answer(ok).
