% Reference 3.5, 11: quoted atoms preserve spaces, quotes, and the empty atom.
symbol('two words').
symbol('needs''quote').
symbol('').
answer(symbol, X) :- symbol(X).
%% goal: answer(X0, X1)

