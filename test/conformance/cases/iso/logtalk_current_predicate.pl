% Adapted from Logtalk iso_current_predicate_1_01 through 05.
% Modified for EyeProlog's conformance harness. See test/conformance/THIRD_PARTY.md.
:- dynamic(dog/0).
dog.
elk(X) :- moose(X).

%% goal: predicate_reflection(X0)

predicate_reflection(Arity) :-
    current_predicate(dog/0),
    current_predicate(elk/Arity),
    \+ current_predicate(foo/_).
