%% goal: answer(X0)

p(a) :- q(a).
q(a) :- r(a).
r(a) :- \+ p(a).
seed(ok).
answer(X) :- seed(X).
