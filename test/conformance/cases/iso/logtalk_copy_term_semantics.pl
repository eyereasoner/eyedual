% Adapted from Logtalk iso_copy_term_2_01 through 08 and 10 through 11.
% Modified for EyeProlog's conformance harness. See test/conformance/THIRD_PARTY.md.
%% goal: copy_term_semantics


copy_term_semantics :-
    copy_term(_, _),
    copy_term(_, 3),
    copy_term(_, a),
    copy_term(a+X, X+b),
    X == a,
    copy_term(Y+Y+_, A+B+B),
    A == B,
    \+ copy_term(a, b),
    \+ copy_twice_succeeds,
    Term1 = pair(P, Q),
    Term2 = pair(R, S),
    copy_term(Term1, Term2),
    P \== R,
    P \== S,
    Q \== R,
    Q \== S.

copy_twice_succeeds :-
    copy_term(a+Z, Z+b),
    copy_term(a+Z, Z+b).
