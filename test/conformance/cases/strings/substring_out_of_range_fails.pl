%% goal: answer(X0)

answer(ok) :- \+ substring('abc', 2, 5, Text).
