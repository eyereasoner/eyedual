% Reference 7.3, 9.2, 9.5: finite arithmetic recursion works with generated ranges.
%% goal: answer(X0, X1)

even(0).
even(N) :- (N > 0), (M is N - 1), odd(M).
odd(N) :- (N > 0), (M is N - 1), even(M).
answer(even, N) :- between(0, 6, N), even(N).
answer(odd, N) :- between(0, 6, N), odd(N).
