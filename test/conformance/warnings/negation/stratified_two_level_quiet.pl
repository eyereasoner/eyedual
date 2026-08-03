%% goal: answer(X0)

base(a).
blocked(b).
allowed(X) :- base(X), \+ blocked(X).
answer(X) :- allowed(X).
