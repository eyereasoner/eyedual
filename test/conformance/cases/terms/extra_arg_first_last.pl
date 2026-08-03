%% goal: answer(X0, X1, X2)

answer(arg_first_last, First, Last) :- arg(1, triple(a, b, c), First), arg(3, triple(a, b, c), Last).
