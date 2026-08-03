%% goal: answer(X0, X1)

answer(nested_list_binding, Tail) :- ([a, b | Tail] = [a, b, c]).
