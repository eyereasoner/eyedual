% Reference 9.7: list patterns, select/3, and ISO negation compose directly.
answer(tail, X) :- [_head|X] = [a, b, c].
answer(select, selected(X, R)) :- select(X, [a, b], R).
answer(absent, true) :- \+ member(c, [a, b]).
%% goal: answer(X0, X1)
