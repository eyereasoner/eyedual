%% goal: answer(X0, X1)

answer(Choice, Built) :-
    ';'(=(Choice, first), =(Choice, second)),
    '=..'(Built, [pair, Choice, ok]),
    call(nonvar(Built)),
    \+(=(Choice, missing)).
