score(alpha, 7).
score(beta, 3).
score(gamma, 5).
answer(min, result(Bests, Best)) :- aggregate_min(S, item(Name, S), score(Name, S), Bests, Best).
%% goal: answer(X0, X1)

