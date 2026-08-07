% Adapted from Logtalk iso_char_code_2_01 through 05.
% Modified for EyeProlog's conformance harness. See test/conformance/THIRD_PARTY.md.
%% goal: char_code_results(X0, X1, X2)

char_code_results(A, C, B) :-
    char_code(a, A),
    char_code(C, 99),
    char_code(c, 99),
    char_code(b, B).
