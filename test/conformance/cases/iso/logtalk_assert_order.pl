% Adapted from Logtalk asserta/1 and assertz/1 ISO examples.
% Modified for EyeProlog's conformance harness. See test/conformance/THIRD_PARTY.md.
:- dynamic(item/1).
item(middle).
%% goal: assert_order(X0)

assert_order(Items) :-
    asserta(item(first)),
    assertz(item(last)),
    findall(X, item(X), Items).
