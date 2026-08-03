%% goal: answer(X0)

item(a).
item(b).
blocked(b).
answer(X) :- item(X), \+ blocked(X).
