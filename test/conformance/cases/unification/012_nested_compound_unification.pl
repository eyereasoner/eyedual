% Reference 5.3, 7.1: unification follows nested compound term structure.
fact(pair(a, nested(b, [c, d]))).
answer(middle, X) :- fact(pair(a, nested(X, [c, d]))).
answer(list_tail, T) :- fact(pair(a, nested(b, [c | T]))).
%% goal: answer(X0, X1)

