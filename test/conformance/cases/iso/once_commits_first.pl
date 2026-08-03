% Isolated ISO mode-table success case.
%% goal: answer

choice(first).
choice(second).
answer :- once(choice(X)), X = first.
