% From The Art of Eyepl, Chapter 33 — B.3.2 List predicates.
answer(split, pair(Prefix, Suffix)) :-
  append(Prefix, Suffix, [a, b]).

answer(second, Item) :-
  nth0(1, [a, b, c], Item).

query(answer(Kind, Value)).
