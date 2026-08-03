% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl.
% Upstream cases: 147-156 and 159-161. See
% test/conformance/THIRD_PARTY.md.

:- op(9, fy, fy).
:- op(9, yf, yf).
:- op(9, yfx, yfx).
:- op(9, xfy, xfy).

%% goal: scryer_operator_precedence(A, B, C, D)

scryer_operator_precedence(A, B, C, D) :-
    A = (fy 1 yf),
    B = (fy 1 yfx 2),
    C = (1 xfy 2 yf),
    D = (fy fy 0).
