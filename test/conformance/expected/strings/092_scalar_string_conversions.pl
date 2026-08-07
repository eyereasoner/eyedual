answer(number_to_string, '42').
answer(decimal_string_to_number, -12.75).
answer(scientific_string_to_number, 1000.0).
answer(atom_to_string, 'hello-world').
answer(string_to_atom_needs_quotes, 'hello-world').
answer(term_to_string, 'result([a, b], score(10))').
answer(unbound_term_rejected, ok).
