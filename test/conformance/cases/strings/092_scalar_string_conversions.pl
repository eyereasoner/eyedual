% Reference 9.6: number_string/2, atom_string/2, and term_string/2 are portable scalar bridges.
%% goal: answer(X0, X1)

answer(number_to_string, X) :- number_string(42, X).
answer(decimal_string_to_number, X) :- number_string(X, '-12.75').
answer(scientific_string_to_number, X) :- number_string(X, '1e3').
answer(atom_to_string, X) :- atom_string('hello-world', X).
answer(string_to_atom_needs_quotes, X) :- atom_string(X, 'hello-world').
answer(term_to_string, X) :- term_string(result([a, b], score(10)), X).
answer(unbound_term_rejected, ok) :- \+ term_string(X, S).
