% Integer-preserving unary arithmetic.
%% goal: answer(X0, X1)

answer(neg, X) :- (X is -(7)).
answer(abs, X) :- (X is abs(-7)).
