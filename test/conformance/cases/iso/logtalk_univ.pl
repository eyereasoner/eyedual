% Adapted from Logtalk iso_univ_2_01 through 06 and lgt_univ_2_19 through 30.
% Modified for EyeProlog's conformance harness. See test/conformance/THIRD_PARTY.md.
%% goal: univ_results(X0, X1, X2, X3, X4)

univ_results(Built, Compound, Atom, List, Number) :-
    Built =.. [foo, a, b],
    foo(a, b) =.. Compound,
    a =.. Atom,
    [1] =.. List,
    1.0 =.. Number,
    \+ (foo(a, b) =.. [foo, b, a]),
    \+ (1 =.. [_, _]),
    \+ (a =.. []).
