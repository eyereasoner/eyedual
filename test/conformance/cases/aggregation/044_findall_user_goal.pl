% Reference 9.8: findall/3 collects templates for every solution of a user goal.
p(b).
p(a).
p(b).
answer(bag, X) :- findall(P, p(P), X).
%% goal: answer(X0, X1)

