%% goal: answer(X0)

item(a).
item(b).
good(a).
answer(ok) :- item_counterexample.
item_counterexample :- item(X), \+ good(X).
