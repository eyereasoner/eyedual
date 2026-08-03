%% goal: answer(X0, X1)

answer(append_split, pair(Left, Right)) :- append(Left, Right, [a, b, c]).
