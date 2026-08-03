%% goal: answer(X0, X1, X2)

score(2, b).
score(1, a).
answer(aggregate_min, Key, Value) :- aggregate_min(K, V, score(K, V), Key, Value).
