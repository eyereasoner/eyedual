elk(milo).
insect(ant).

%% goal: answer(X0, X1, X2, X3)

answer(Unified, First, Arity, Repeated) :-
    unify_with_occurs_check(pair(X, X), pair(ok, Y)),
    =(Unified, pair(X, Y)),
    once(atom_concat(First, Tail, ab)),
    =(Tail, ab),
    current_predicate(elk/Arity),
    once(repeat),
    =(Repeated, true),
    \+(unify_with_occurs_check(Cycle, f(Cycle))).
