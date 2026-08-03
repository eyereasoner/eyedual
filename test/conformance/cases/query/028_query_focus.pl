% Reference 10.2, 11: host-supplied goals restrict selected default predicate groups.
%% goal: answer(X0, X1)

seed(a).
helper(X, y) :- seed(X).
answer(X, ok) :- helper(X, y).
