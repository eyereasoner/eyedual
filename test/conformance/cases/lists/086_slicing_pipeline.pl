% Reference 9.7: list patterns and last/take/drop/slice compose deterministically.
%% goal: answer(X0, X1)

data([zero, one, two, three, four]).
answer(first, X) :- data([X|_tail]).
answer(tail, X) :- data([_head|X]).
answer(last, X) :- data(L), last(L, X).
answer(take_three, X) :- data(L), take(3, L, X).
answer(drop_three, X) :- data(L), drop(3, L, X).
answer(slice_middle, X) :- data(L), slice(1, 3, L, X).
answer(slice_tail_empty, X) :- data(L), slice(5, 0, L, X).
