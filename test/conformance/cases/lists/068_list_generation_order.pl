% Reference 9.1: reusable list relations enumerate in stable left-to-right order.
query(answer(X0, X1)).
answer(append_split, pair(Prefix, Suffix)) :- append(Prefix, Suffix, [a, b]).
answer(nth, pair(Index, Value)) :- nth0(Index, [x, y], Value).
answer(select, pair(Value, Rest)) :- select(Value, [a, b, a], Rest).
answer(not_member_atom, ok) :- not_member(z, [a, b, c]).
answer(not_member_unifiable_rejected, ok) :- \+ not_member(pair(X), [pair(a)]).
