% Reference 5.3, 6, 7.1: structured rule heads destructure matching goals.
unpack(pair(X, Y), X, Y).
answer(first, A) :- unpack(pair(alpha, beta), A, _).
answer(second, B) :- unpack(pair(alpha, beta), _, B).
%% goal: answer(X0, X1)

