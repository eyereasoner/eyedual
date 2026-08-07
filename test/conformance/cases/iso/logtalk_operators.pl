% Adapted from Logtalk op/3 tests 01, 02, 09, 18, 32, and 33 and
% current_op/3 tests 01 through 39. Modified for EyeProlog's harness.
% See test/conformance/THIRD_PARTY.md.
%% goal: operator_results(X0, X1, X2)

operator_results(RulePriority, PlusPriority, PlusSpecifier) :-
    current_op(RulePriority, xfx, ':-'),
    current_op(PlusPriority, PlusSpecifier, '+'),
    PlusPriority = 500,
    PlusSpecifier = yfx,
    op(333, xfy, [abc, abc, abc]),
    current_op(333, xfy, abc),
    op(30, xfy, '++'),
    current_op(30, xfy, '++'),
    op(0, xfy, '++'),
    \+ current_op(_, xfy, '++'),
    op(0, fx, unused),
    \+ current_op(_, _, unused).
