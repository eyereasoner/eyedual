item(a).
item(b).
answer(counts, counts(C, Z)) :- countall(item(X), C), countall(missing(X), Z).
%% goal: answer(X0, X1)

