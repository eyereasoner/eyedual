%% goal: answer(X0, X1)

answer(member_repeated_nested, X) :- member(pair(X, X), [pair(a, a), pair(a, b), pair(b, b)]).
