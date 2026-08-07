% Adapted from Logtalk tests/prolog/predicates/compare_3/tests.lgt
% (iso_compare_3_01 through iso_compare_3_04 and lgt_compare_3_07 through 15).
% Modified for EyeProlog's conformance harness. See test/conformance/THIRD_PARTY.md.
%% goal: compare_results(X0, X1, X2, X3)


compare_results(ThreeFive, Same, FloatInteger, Shapes) :-
    compare(ThreeFive, 3, 5),
    compare(Same, d, d),
    \+ compare('<', '<', '<'),
    compare('<', Variable, 1.1),
    compare(FloatInteger, 1.1, 1),
    compare('>', 1, 1.1),
    compare('<', 1, a),
    compare('<', a, a(Variable)),
    compare(Shapes, a(1), a(1, 2)).
