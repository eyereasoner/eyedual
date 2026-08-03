%% goal: answer(X0, X1)

answer(sum, X) :- sum_list([5, -2, 7], X).
answer(min, X) :- min_list([5, -2, 7], X).
answer(max, X) :- max_list([5, -2, 7], X).
