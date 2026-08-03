score(alpha, 7).
score(beta, 7).
score(gamma, 5).
answer(max, result(Key, Bestname)) :- aggregate_max([S, Name], Name, score(Name, S), Key, Bestname).
%% goal: answer(X0, X1)

