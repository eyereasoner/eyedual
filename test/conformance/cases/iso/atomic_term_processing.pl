%% goal: answer(X0, X1, X2, X3, X4, X5, X6, X7)

answer(Length, Joined, Sub, Chars, Codes, Char, Number1, Number2) :-
    atom_length('enchanted evening', Length),
    atom_concat(small, ' world', Joined),
    sub_atom(abracadabra, 3, 5, 3, Sub),
    atom_chars(ant, Chars),
    atom_codes(ant, Codes),
    char_code(Char, 99),
    number_chars(Number1, ['-', '2', '5']),
    number_codes(Number2, [52, 46, 50]).

%% goal: split(X0, X1)

split(Left, Right) :-
    atom_concat(Left, Right, ab).

%% goal: occurrence(X0, X1, X2)

occurrence(Before, Length, After) :-
    sub_atom(abracadabra, Before, Length, After, ab).
