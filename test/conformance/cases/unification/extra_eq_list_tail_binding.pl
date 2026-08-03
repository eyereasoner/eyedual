%% goal: answer(X0, X1)

answer(eq_list_tail_binding, Tail) :- ([a, b | Tail] = [a, b, c, d]).
