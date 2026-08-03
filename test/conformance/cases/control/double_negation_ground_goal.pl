%% goal: answer(X0)

seed(a).
answer(ok) :- \+ \+ seed(a).
