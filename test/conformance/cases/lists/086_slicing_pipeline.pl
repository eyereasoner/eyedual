% Reference 9.7: head/rest/last/take/drop/slice are deterministic reusable list operations.
%% goal: answer(X0, X1)

data([zero, one, two, three, four]).
answer(head, X) :- data(L), head(L, X).
answer(rest, X) :- data(L), rest(L, X).
answer(last, X) :- data(L), last(L, X).
answer(take_three, X) :- data(L), take(3, L, X).
answer(drop_three, X) :- data(L), drop(3, L, X).
answer(slice_middle, X) :- data(L), slice(1, 3, L, X).
answer(slice_tail_empty, X) :- data(L), slice(5, 0, L, X).
