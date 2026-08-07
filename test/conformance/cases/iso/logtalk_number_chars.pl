% Adapted from Logtalk iso_number_chars_2_01 through 08 and 11 through 13.
% Modified for EyeProlog's conformance harness. See test/conformance/THIRD_PARTY.md.
%% goal: number_char_results(X0, X1, X2, X3)

number_char_results(IntegerChars, Float, Negative, Spaced) :-
    number_chars(33, IntegerChars),
    number_chars(33.0, FloatChars),
    number_chars(Float, FloatChars),
    number_chars(Negative, ['-', '2', '5']),
    number_chars(Spaced, [' ', '3']),
    number_chars(4.2, ['4', '.', '2']),
    number_chars(0.1, Chars),
    number_chars(0.1, Chars).
