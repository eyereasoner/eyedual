%% goal: answer(X0, X1)

edge(a, b).
edge(b, c).
answer(table_open_call_fallback, pair(X, Y)) :- edge(X, Y).
