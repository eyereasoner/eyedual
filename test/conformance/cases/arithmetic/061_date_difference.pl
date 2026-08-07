% Reference 9.1: difference/3 computes ISO date durations.
answer(duration, D) :- difference('2024-03-01', '2020-02-29', D).
answer(month_borrow, D) :- difference('2024-03-01', '2024-01-31', D).
%% goal: answer(X0, X1)

