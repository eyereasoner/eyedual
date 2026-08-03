%% goal: answer(X0, X1)

answer(Item, Rest) :- select(Item, [a, b, a], Rest).
