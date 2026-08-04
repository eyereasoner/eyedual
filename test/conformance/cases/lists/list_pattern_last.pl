%% goal: answer(X0, X1)

answer(first, X) :- [X|_tail] = [a, b, c].
answer(tail, X) :- [_head|X] = [a, b, c].
answer(last, X) :- last([a, b, c], X).
