%% goal: answer(X0)

choice(a).
choice(b).
answer(X) :- once(choice(X)).
