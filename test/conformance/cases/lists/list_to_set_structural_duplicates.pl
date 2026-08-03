%% goal: answer(X0)

answer(X) :- list_to_set([pair(a, 1), pair(a, 1), pair(a, 2)], X).
