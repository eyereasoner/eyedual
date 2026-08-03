% Adapted from Trealla Prolog tests/tests/test077.pl.
% See test/conformance/THIRD_PARTY.md.
:- dynamic(insect/1).

insect(ant).
insect(bee).

%% goal: logical_update(X)

logical_update(X) :-
    retract(insect(X)),
    (X = ant -> retract(insect(bee)); true).
