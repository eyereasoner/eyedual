% Isolated ISO mode-table success case.
%% goal: answer

answer :- \+ unify_with_occurs_check(X, f(X)).
