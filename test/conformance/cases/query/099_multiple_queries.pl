% Reference 11.2 and 13: host-supplied goals can select several predicate arities explicitly.
%% goal: answer(X0)

%% goal: answer(X0, X1)

seed(a).
seed(b).
answer(X) :- seed(X).
answer(X, doubled) :- seed(X).
answer(hidden, X, Y) :- seed(X), seed(Y).
