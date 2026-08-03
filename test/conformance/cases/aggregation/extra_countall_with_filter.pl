%% goal: answer(X0, X1)

num(1).
num(2).
num(3).
answer(countall_with_filter, N) :- countall((num(X), (X > 1)), N).
