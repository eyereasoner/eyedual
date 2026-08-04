% Reference 9.1: reusable list selectors and slices have explicit finite boundary behavior.
%% goal: answer(X0, X1)

answer(take_zero, X) :- take(0, [a, b, c], X).
answer(drop_all, X) :- drop(3, [a, b, c], X).
answer(slice_empty, X) :- slice(1, 0, [a, b, c], X).
answer(last_single, X) :- last([only], X).
answer(first_tail, pair(H, R)) :- [H|R] = [a, b, c].
answer(take_too_many_rejected, ok) :- \+ take(4, [a, b, c], X).
answer(drop_too_many_rejected, ok) :- \+ drop(4, [a, b, c], X).
answer(last_empty_rejected, ok) :- \+ last([], X).
