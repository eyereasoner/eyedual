:- dynamic(item/1).
:- dynamic(temp/1).

item(old).
temp(a).
temp(b).

%% goal: database_roundtrip(X0, X1, X2)

database_roundtrip(All, Remaining, RuleBody) :-
    asserta(item(first)),
    assertz(item(last)),
    findall(Value, item(Value), All),
    assertz((derived(X) :- item(X))),
    clause(derived(selected), RuleBody),
    retract(item(old)),
    findall(Value, item(Value), Remaining),
    abolish(derived/1),
    \+(current_predicate(derived/1)).

%% goal: retracted(X0)

retracted(Value) :-
    retract(temp(Value)).
