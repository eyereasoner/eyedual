% Reference 12: once/1 proof output includes the proof for the selected child goal.
%% goal: answer(X0)

choice(a).
choice(b).
answer(X) :- once(choice(X)).
