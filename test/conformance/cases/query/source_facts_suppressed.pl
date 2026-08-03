% host execution prints derived answers, not source facts for the same predicate.
%% goal: answer(X0)

seed(a).
answer(source).
answer(X) :- seed(X).
