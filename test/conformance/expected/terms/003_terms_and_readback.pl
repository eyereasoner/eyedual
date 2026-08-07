value(atom, pat).
value(quoted_atom, 'atom with spaces').
value(quoted_quote, 'needs''quote').
value(empty_atom, '').
value(char_list, "line\nquote: \"ok\"").
value(integer, -42).
value(decimal, 0.25).
value(scientific, 1.25e-3).
value(compound, pair(3, nested(atom, "xy"))).
value(arity_zero_atom, nil).
value(empty_list, []).
value(proper_list, "abc").
value(improper_list, [a, b | tail]).
