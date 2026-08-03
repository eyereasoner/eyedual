% Negation fails when its inner goal succeeds.
%% goal: answer(X0)

seen(a).
answer(ok) :- \+ seen(a).
