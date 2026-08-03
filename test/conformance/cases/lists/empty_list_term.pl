% The empty list is a first-class term.
%% goal: answer(X0)

seed([]).
answer(X) :- seed(X).
