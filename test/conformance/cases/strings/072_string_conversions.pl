% Reference 9.1: string/atom/number conversions are deterministic in documented modes.
%% goal: answer(X0, X1)

answer(number_to_string, X) :- number_string(-7, X).
answer(string_to_integer, X) :- number_string(X, '123').
answer(string_to_decimal, X) :- number_string(X, '-3.5').
answer(non_numeric_rejected, ok) :- \+ number_string(X, 'abc').
answer(atom_to_string, X) :- atom_string(hello_world, X).
answer(string_to_atom, X) :- atom_string(X, 'hello_world').
answer(number_to_atom, X) :- atom_string(X, 123).
answer(trim_to_empty, X) :- trim('   ', X).
