% Reference 9.6: string case and trim built-ins preserve non-letter characters.
%% goal: answer(X0, X1)

answer(lower_mixed, X) :- lowercase('Hello WORLD 123!', X).
answer(upper_mixed, X) :- uppercase('Hello world 123!', X).
answer(trim_spaces, X) :- trim('  padded  ', X).
answer(trim_tabs_newline, X) :- trim('\tvalue\n', X).
answer(trim_empty, X) :- trim('', X).
