%% goal: answer(X0)

answer(ok) :- \+ matches('abc', 'x|y').
