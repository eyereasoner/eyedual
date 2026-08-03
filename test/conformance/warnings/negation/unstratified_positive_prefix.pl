%% goal: answer(X0)

p(a) :- helper(a).
helper(a) :- \+ q(a).
q(a) :- p(a).
answer(ok).
