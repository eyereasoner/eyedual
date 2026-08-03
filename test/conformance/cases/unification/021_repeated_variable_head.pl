% Reference 5.1, 7.1: repeated variables in a rule body require the same term.
pair(a, a).
pair(a, b).
pair(c, c).
diagonal(X) :- pair(X, X).
answer(diagonal, X) :- diagonal(X).
%% goal: answer(X0, X1)

