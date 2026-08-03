% Reference 7.2: a failing subgoal removes that candidate answer.
candidate(a).
candidate(b).
allowed(a).
answer(X, ok) :- candidate(X), allowed(X).

%% goal: answer(X0, X1)

