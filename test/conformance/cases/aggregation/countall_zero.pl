%% goal: answer(X0)

answer(N) :- countall(missing(X), N).
