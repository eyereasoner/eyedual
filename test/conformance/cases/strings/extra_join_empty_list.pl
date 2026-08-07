%% goal: answer(X0, X1)

answer(join_empty_list, X) :- join([], ',', X).
