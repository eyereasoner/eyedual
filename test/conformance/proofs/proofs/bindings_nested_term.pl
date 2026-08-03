% Reference 12: proof bindings preserve nested compound terms.
%% goal: answer(X0)

source(pair(a, [b, c])).
answer(Term) :- source(Term).
