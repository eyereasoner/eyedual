% Negation succeeds when its inner goal has no solution.
%% goal: answer(X0)

answer(ok) :- \+ missing(fact).
