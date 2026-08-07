% Adapted from Logtalk iso_arg_3_01 through 07, eddbali_arg_3_15, and
% lgt_arg_3_17 through 19. Modified for EyeProlog's conformance harness.
% See test/conformance/THIRD_PARTY.md.
%% goal: arg_results(X0, X1, X2, X3)


arg_results(First, Unified, Head, Tail) :-
    arg(1, foo(a, b), First),
    arg(1, foo(Unified, b), a),
    \+ arg(1, foo(a, b), b),
    \+ arg(0, foo(a, b), foo),
    \+ arg(3, foo(3, 4), _),
    arg(2, foo(a, f(X, b), c), f(a, Y)),
    X == a,
    Y == b,
    arg(1, [Head | _], Head),
    Head = head,
    arg(2, [_ | Tail], Tail),
    Tail = [rest].
