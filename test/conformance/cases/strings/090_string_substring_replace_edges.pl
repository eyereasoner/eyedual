% Reference 9.6: substring and replace have finite boundary behavior.
%% goal: answer(X0, X1)

answer(prefix, X) :- substring("eyeduallanglet", 0, 7, X).
answer(middle, X) :- substring("eyeduallanglet", 7, 2, X).
answer(suffix, X) :- substring("eyeduallanglet", 6, 3, X).
answer(empty_at_end, X) :- substring("eyeduallanglet", 14, 0, X).
answer(out_of_range_rejected, ok) :- \+ substring("eyeduallanglet", 14, 2, X).
answer(replace_all, X) :- replace("banana", "na", "NA", X).
answer(replace_missing, X) :- replace("banana", "x", "y", X).
