% Adapted from SWI-Prolog tests/core/test_occurs_check.pl.
% See test/conformance/THIRD_PARTY.md.

%% goal: swipl_occurs_check(ok)

swipl_occurs_check(ok) :-
    \+ unify_with_occurs_check(A, list(A)),
    unify_with_occurs_check(B, C),
    unify_with_occurs_check(D, D),
    var(B),
    var(C),
    var(D).
