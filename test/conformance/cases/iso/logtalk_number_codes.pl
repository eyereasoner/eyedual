% Adapted from Logtalk iso_number_codes_2_01 through 06 and 09 through 11.
% Modified for EyeProlog's conformance harness. See test/conformance/THIRD_PARTY.md.
%% goal: number_code_results(X0, X1, X2, X3)

number_code_results(IntegerCodes, Float, Negative, Spaced) :-
    number_codes(33, IntegerCodes),
    number_codes(33.0, FloatCodes),
    number_codes(Float, FloatCodes),
    number_codes(Negative, [45, 50, 53]),
    number_codes(Spaced, [32, 51]),
    number_codes(4.2, [52, 46, 50]),
    number_codes(0.1, Codes),
    number_codes(0.1, Codes).
