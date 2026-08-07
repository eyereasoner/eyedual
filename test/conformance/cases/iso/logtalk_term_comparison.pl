% Adapted from Logtalk iso_term_comparison_01 through 19 and
% lgt_term_comparison_20 through 27. Modified for EyeProlog's conformance harness.
% See test/conformance/THIRD_PARTY.md.
%% goal: term_comparison_order


term_comparison_order :-
    1.0 @< 1,
    aardvark @=< zebra,
    short @=< short,
    short @=< shorter,
    \+ short @>= shorter,
    \+ foo(a, b) @< north(a),
    foo(b) @> foo(a),
    foo(a, _) @< foo(b, _),
    X @=< X,
    X == X,
    A \== B,
    Variable @< 1.1,
    1.1 @< 1,
    1 @< a,
    a @< a(_),
    a(_) @< a(_, _),
    b(_) @< a(_, _),
    a(1, 2) @< a(1, 3),
    a(1, 2) @< b(1, 2).
