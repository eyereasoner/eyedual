% Reference 6: predicate name and arity both identify a predicate group.
p(a).
p(a, b).
answer(unary, X) :- p(X).
answer(binary, pair(X, Y)) :- p(X, Y).
%% goal: answer(X0, X1)

