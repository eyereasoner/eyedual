% Reference 9.1: reusable string built-ins cover empty results and scalar list items.
%% goal: answer(X0, X1)

answer(split_missing_separator, X) :- split('abc', ',', X).
answer(split_empty_separator, X) :- split('abc', '', X).
answer(join_empty, X) :- join([], ',', X).
answer(join_numbers, X) :- join([1, 2, 3], '-', X).
answer(substring_empty, X) :- substring('abcdef', 2, 0, X).
answer(replace_empty_search, X) :- replace('abc', '', 'x', X).
answer(lower_string, X) :- lowercase('Hello', X).
answer(upper_string, X) :- uppercase('EyeProlog 123', X).
