%% goal: answer(X0)

p(X) :- q(X), \+ r(X).
q(a).
r(X) :- p(X).
answer(ok).
