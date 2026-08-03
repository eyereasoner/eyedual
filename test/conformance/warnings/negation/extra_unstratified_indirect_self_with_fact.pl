%% goal: answer(X0)

seed(a).
p(X) :- seed(X), \+ blocked(X).
blocked(X) :- p(X).
answer(ok).
