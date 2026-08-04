% Reference 9.1: reusable list selectors, slices, summaries, and stable set conversion.
%% goal: answer(X0, X1)

answer(first, X) :- [X|_tail] = [alpha, beta, gamma, beta].
answer(last, X) :- last([alpha, beta, gamma, beta], X).
answer(take, X) :- take(2, [alpha, beta, gamma, beta], X).
answer(drop, X) :- drop(2, [alpha, beta, gamma, beta], X).
answer(slice, X) :- slice(1, 2, [alpha, beta, gamma, beta], X).
answer(sum, X) :- sum_list([1, 2, 3.5], X).
answer(min, X) :- min_list([3, 1, 2], X).
answer(max, X) :- max_list([3, 1, 2], X).
answer(set, X) :- list_to_set([beta, alpha, beta, gamma, alpha], X).
