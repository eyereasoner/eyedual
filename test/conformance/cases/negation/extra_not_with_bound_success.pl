%% goal: answer(X0, X1)

known(a).
answer(not_with_bound_success, b) :- \+ known(b).
