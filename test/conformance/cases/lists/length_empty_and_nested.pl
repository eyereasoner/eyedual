%% goal: answer(X0, X1)

answer(empty, X) :- length([], X).
answer(nested, X) :- length([[a], [b, c]], X).
