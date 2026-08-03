% Improper lists preserve their tail in read-back.
%% goal: answer(X0)

seed([a, b | tail]).
answer(X) :- seed(X).
