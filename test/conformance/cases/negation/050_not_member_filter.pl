% Reference 9.7: not_member/2 can filter finite candidates.
candidate(a).
candidate(b).
candidate(c).
answer(not_present, X) :- candidate(X), not_member(X, [a, b]).
%% goal: answer(X0, X1)

