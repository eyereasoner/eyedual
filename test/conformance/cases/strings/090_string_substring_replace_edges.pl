% Reference 9.6: substring and replace have finite boundary behavior.
%% goal: answer(X0, X1)

answer(prefix, X) :- substring("eyepllanglet", 0, 5, X).
answer(middle, X) :- substring("eyepllanglet", 5, 2, X).
answer(suffix, X) :- substring("eyepllanglet", 4, 3, X).
answer(empty_at_end, X) :- substring("eyepllanglet", 12, 0, X).
answer(out_of_range_rejected, ok) :- \+ substring("eyepllanglet", 12, 2, X).
answer(replace_all, X) :- replace("banana", "na", "NA", X).
answer(replace_missing, X) :- replace("banana", "x", "y", X).
