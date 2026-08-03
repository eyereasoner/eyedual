% Reference 9.6: substring and replace have finite boundary behavior.
%% goal: answer(X0, X1)

answer(prefix, X) :- substring("webentaillanglet", 0, 9, X).
answer(middle, X) :- substring("webentaillanglet", 9, 2, X).
answer(suffix, X) :- substring("webentaillanglet", 8, 3, X).
answer(empty_at_end, X) :- substring("webentaillanglet", 16, 0, X).
answer(out_of_range_rejected, ok) :- \+ substring("webentaillanglet", 16, 2, X).
answer(replace_all, X) :- replace("banana", "na", "NA", X).
answer(replace_missing, X) :- replace("banana", "x", "y", X).
