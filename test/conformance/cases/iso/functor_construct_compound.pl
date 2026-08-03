% Isolated ISO mode-table success case.
%% goal: answer

answer :- functor(Term, made, 2), Term = made(left, right).
