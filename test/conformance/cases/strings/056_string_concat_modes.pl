% SWI-style string_concat/3 concatenates, checks, and splits text.
answer(concat, X) :- string_concat('eye', 'prolog', X).
answer(check, true) :- string_concat('eye', 'prolog', 'eyeprolog').
answer(prefix, X) :- string_concat(X, 'prolog', 'eyeprolog').
answer(suffix, X) :- string_concat('eye', X, 'eyeprolog').
answer(split, Left, Right) :- string_concat(Left, Right, 'eye').
answer(atom_inputs, X) :- string_concat(eye, prolog, X).
%% goal: answer(X0, X1)
%% goal: answer(X0, X1, X2)
