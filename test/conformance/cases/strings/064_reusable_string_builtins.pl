% Reference 9.1: reusable string normalization, splitting, joining, replacement, and conversions.
%% goal: answer(X0, X1)

answer(trim, X) :- trim('  Hello EyeProlog  ', X).
answer(lower, X) :- lowercase('Hello EyeProlog', X).
answer(upper, X) :- uppercase('Hello EyeProlog', X).
answer(split, X) :- split('red,green,blue', ',', X).
answer(join, X) :- join([red, green, blue], ':', X).
answer(substring, X) :- substring('abcdef', 2, 3, X).
answer(replace, X) :- replace('red-green-red', 'red', 'blue', X).
answer(number_to_string, X) :- number_string(42, X).
answer(string_to_number, X) :- number_string(X, '3.5').
answer(atom_string, X) :- atom_string(eyeprolog, X).
