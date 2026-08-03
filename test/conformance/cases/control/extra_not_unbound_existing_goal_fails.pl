%% goal: answer(X0)

p(a).
answer(not_unbound_existing_goal_fails) :- \+ p(X).
