% Reference 9.1: reusable list relations enumerate in stable left-to-right order.
%% goal: answer(X0, X1)

answer(append_split, pair(Prefix, Suffix)) :- append(Prefix, Suffix, [a, b]).
answer(nth, pair(Index, Value)) :- nth0(Index, [x, y], Value).
answer(select, pair(Value, Rest)) :- select(Value, [a, b, a], Rest).
answer(absent_atom, ok) :- \+ member(z, [a, b, c]).
