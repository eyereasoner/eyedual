%% goal: answer(X0, X1, X2, X3)

answer(X, Kind, Order, CopyDistinct) :-
    =(X, foo),
    atom(X),
    nonvar(X),
    compare(Order, 1, 2),
    copy_term(pair(A, A), pair(B, C)),
    ==(B, C),
    \==(A, B),
    =(CopyDistinct, true),
    =(Kind, atom).
