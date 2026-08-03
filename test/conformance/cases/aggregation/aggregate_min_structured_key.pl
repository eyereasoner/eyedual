%% goal: answer(X0, X1)

candidate(a, 3).
candidate(b, 1).
candidate(c, 2).
answer(Key, Value) :- aggregate_min(score(Score), Name, candidate(Name, Score), Key, Value).
