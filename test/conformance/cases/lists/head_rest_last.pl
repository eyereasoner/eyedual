%% goal: answer(X0, X1)

answer(head, X) :- head([a, b, c], X).
answer(rest, X) :- rest([a, b, c], X).
answer(last, X) :- last([a, b, c], X).
