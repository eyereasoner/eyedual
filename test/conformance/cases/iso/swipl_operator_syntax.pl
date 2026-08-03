% Adapted from SWI-Prolog tests/core/test_op.pl, current_op and op_syntax.
% See test/conformance/THIRD_PARTY.md.

:- op(100, xf, xf100).
:- op(200, xf, xf200).
:- op(100, fx, fx100).
:- op(100, yf, yf100).
:- op(900, xfy, xfy900).

%% goal: swipl_standard_plus(Priority, Specifier)

swipl_standard_plus(Priority, Specifier) :-
    current_op(Priority, Specifier, '+').

%% goal: swipl_operator_syntax(A, B, C)

swipl_operator_syntax(A, B, C) :-
    A = (xf100 xf200),
    B = (fx100 1 xf200),
    C = (p, q yf100 xfy900 c).
