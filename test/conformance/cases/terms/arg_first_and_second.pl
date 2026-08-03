%% goal: answer(X0, X1)

answer(first, X) :- arg(1, pair(a, b), X).
answer(second, X) :- arg(2, pair(a, b), X).
