%% goal: answer(X0)

p(a) :- \+ q(a).
q(a) :- \+ p(a).
r(a) :- \+ s(a).
s(a) :- \+ r(a).
answer(ok).
