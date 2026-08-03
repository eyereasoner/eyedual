%% goal: answer(X0)

known(a).
answer(not_with_bound_fails) :- \+ known(a).
