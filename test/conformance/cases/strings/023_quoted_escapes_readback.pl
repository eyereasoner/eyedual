% Reference 3.5, 11: double-quoted lists and quoted atoms preserve escapes at read-back.
raw(char_list, "line\nnext\t\\slash").
raw(atom, 'line\nnext\t\\slash').
answer(K, V) :- raw(K, V).
%% goal: answer(X0, X1)
