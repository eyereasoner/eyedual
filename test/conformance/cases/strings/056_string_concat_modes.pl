% SWI-style string_concat/3 concatenates, checks, and splits text.
answer(concat, X) :- string_concat("eye", "dual", X).
answer(check, true) :- string_concat("eye", "dual", "eyedual").
answer(prefix, X) :- string_concat(X, "dual", "eyedual").
answer(suffix, X) :- string_concat("eye", X, "eyedual").
answer(split, Left, Right) :- string_concat(Left, Right, "eye").
answer(atom_inputs, X) :- string_concat(eye, dual, X).
%% goal: answer(X0, X1)
%% goal: answer(X0, X1, X2)
