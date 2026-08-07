% Adapted from Logtalk iso_retract_1_01 through 06.
% Modified for EyeProlog's conformance harness. See test/conformance/THIRD_PARTY.md.
:- dynamic(insect/1).
insect(ant). insect(bee).
:- dynamic(legs/2).
legs(octopus, 8).
legs(A, 6) :- insect(A).
%% goal: retract_results(X0, X1)

retract_results(Body, FirstInsect) :-
    retract(legs(octopus, 8)),
    \+ retract(legs(spider, 6)),
    retract((legs(X, 6) :- Body)),
    X = ant,
    retract(insect(FirstInsect)),
    retract(insect(bee)).
