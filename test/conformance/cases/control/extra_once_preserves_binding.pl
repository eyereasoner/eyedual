%% goal: answer(X0, X1)

answer(once_preserves_binding, X) :- once(member(X, [a, b])).
