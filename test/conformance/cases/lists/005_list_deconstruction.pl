% Reference 5.4, 12.1: list syntax and unification in rule heads.
first([X | _rest], X).
tail([_head | Tail], Tail).
answer(first, X) :- first([a, b, c], X).
answer(tail, Tail) :- tail([a, b, c], Tail).
%% goal: answer(X0, X1)

