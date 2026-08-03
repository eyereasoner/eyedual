%% goal: answer(X0, X1)

pair_key(pair(a, b)).
answer(structured_head_rule, X) :- pair_key(pair(X, b)).
