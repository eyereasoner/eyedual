% Reference 4, 5.3: arity-zero data is written as an atom constant.
status(nil, ok).
answer(value, X) :- status(X, ok).
%% goal: answer(X0, X1)

