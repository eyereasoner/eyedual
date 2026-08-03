%% goal: answer(X0, X1)

item(a).
item(b).
answer(findall_builtin, Bag) :- findall(X, item(X), Bag).
