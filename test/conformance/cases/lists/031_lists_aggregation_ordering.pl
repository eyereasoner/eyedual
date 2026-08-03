% Reference 9.7, 9.8: list, aggregation, and ordering built-ins.
answer(member, X) :- member(X, [a, b]).
answer(append, X) :- append([a], [b, c], X).
answer(nth0, X) :- nth0(1, [a, b, c], X).
answer(set_nth0, X) :- set_nth0(1, [a, b, c], x, X).
answer(reverse, X) :- reverse([a, b, c], X).
answer(length, N) :- length([a, b, c], N).
answer(findall, X) :- findall(N, between(1, 3, N), X).
answer(sort, X) :- sort([b, a, b], X).
%% goal: answer(X0, X1)

