% Reference 3, 5, 11: scalars, compounds, lists, and read-back printing.
%% goal: value(X0, X1)

raw_value(atom, pat).
raw_value(quoted_atom, 'atom with spaces').
raw_value(quoted_quote, 'needs''quote').
raw_value(empty_atom, '').
raw_value(char_list, "line\nquote: \"ok\"").
raw_value(integer, -42).
raw_value(decimal, 0.25).
raw_value(scientific, 1.25e-3).
raw_value(compound, pair(3, nested(atom, [x, y]))).
raw_value(arity_zero_atom, nil).
raw_value(empty_list, []).
raw_value(proper_list, [a, b, c]).
raw_value(improper_list, [a, b | tail]).
value(K, V) :- raw_value(K, V).
