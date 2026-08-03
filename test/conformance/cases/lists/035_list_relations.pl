% Reference 9.7: rest/2, select/3, and not_member/2.
answer(rest, X) :- rest([a, b, c], X).
answer(select, selected(X, R)) :- select(X, [a, b], R).
answer(not_member, true) :- not_member(c, [a, b]).
%% goal: answer(X0, X1)

