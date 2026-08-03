% Reference 11: query output excludes source facts even if also derivable.
%% goal: answer(X0, X1)

seed(a).
answer(a, ok).
answer(X, ok) :- seed(X).
answer(b, ok) :- seed(a).
