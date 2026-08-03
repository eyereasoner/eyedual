% Reusing a variable name in separate clauses does not connect the clauses.
%% goal: answer(X0)

left(a).
right(b).
answer(X) :- left(X).
answer(X) :- right(X).
