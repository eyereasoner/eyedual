% Reference 3.5, 11: quoted strings and atoms preserve escape sequences at read-back.
raw(string, "line\nnext\t\\slash").
raw(atom, 'line\nnext\t\\slash').
answer(K, V) :- raw(K, V).
%% goal: answer(X0, X1)

