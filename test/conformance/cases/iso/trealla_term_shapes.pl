% Adapted from Trealla Prolog tests/tests/test059.pl, tests 6-9 and 13.
% See test/conformance/THIRD_PARTY.md.

%% goal: term_shapes(ok)

term_shapes(ok) :-
    functor({a,b,c}, {}, 1),
    functor([a,b,c], '.', 2),
    functor((a,b,c), ',', 2),
    arg(1, {a,b,c}, (a,b,c)),
    arg(1, [a,b,c], a),
    arg(2, [a,b,c], [b,c]),
    arg(1, (a,b,c), a),
    arg(2, (a,b,c), (b,c)),
    Constructed =.. [shape, 1, 2],
    Constructed = shape(1, 2),
    shape(1, 2, 3) =.. [shape, 1, 2, 3].
