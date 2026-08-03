%% goal: answer(X0, X1, X2)

left(a).
right(a, one).
right(a, two).
answer(left_to_right_multiple_bindings, X, Y) :- left(X), right(X, Y).
