% Isolated ISO mode-table success case.
%% goal: answer

answer :- copy_term(pair(X, X), pair(A, B)), A = copied, B = copied, var(X).
