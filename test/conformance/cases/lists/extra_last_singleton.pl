%% goal: answer(X0, X1)

answer(last_singleton, X) :- last([only], X).
