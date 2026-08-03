score(a, 4).
score(b, 5).
score(c, -2).
answer(sum, Sum) :- sumall(S, score(_item, S), Sum).
%% goal: answer(X0, X1)

