% Adapted from Logtalk iso_current_prolog_flag_2_01, 02, 05 through 10,
% and eddbali_current_prolog_flag_2_12 through 13. Modified for EyeProlog's harness.
% See test/conformance/THIRD_PARTY.md.
%% goal: prolog_flags(X0, X1, X2, X3, X4)

prolog_flags(Bounded, Rounding, Conversion, Unknown, Quotes) :-
    current_prolog_flag(debug, off),
    current_prolog_flag(bounded, Bounded),
    current_prolog_flag(integer_rounding_function, Rounding),
    current_prolog_flag(char_conversion, Conversion),
    current_prolog_flag(unknown, Unknown),
    current_prolog_flag(double_quotes, Quotes),
    set_prolog_flag(unknown, warning),
    current_prolog_flag(unknown, warning),
    \+ current_prolog_flag(unknown, error).
