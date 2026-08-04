% Reference 9.7: ISO negation can filter finite candidates through member/2.
candidate(a).
candidate(b).
candidate(c).
answer(not_present, X) :- candidate(X), \+ member(X, [a, b]).
%% goal: answer(X0, X1)
