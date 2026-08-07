% Adapted from Logtalk iso_unify_with_occurs_check_2_01 through 17, 19, and 20.
% Modified for EyeProlog's conformance harness. See test/conformance/THIRD_PARTY.md.
%% goal: occurs_check_results(X0, X1)

occurs_check_results(One, Def) :-
    unify_with_occurs_check(One, 1),
    unify_with_occurs_check(X, Y),
    X = shared, Y = shared,
    unify_with_occurs_check(f(A, def), f(def, Def)),
    A = def,
    \+ unify_with_occurs_check(1, 2),
    \+ unify_with_occurs_check(1, 1.0),
    \+ unify_with_occurs_check(g(B), f(f(B))),
    \+ unify_with_occurs_check(C, a(C)),
    \+ unify_with_occurs_check(D, [_ | D]),
    unify_with_occurs_check(f(E, E), f(F, F)),
    E = same, F = same.
