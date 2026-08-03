% Each `_` occurrence is fresh, so these two goals do not have to agree.
%% goal: answer(X0)

pair(a, b).
answer(ok) :- pair(_, _).
