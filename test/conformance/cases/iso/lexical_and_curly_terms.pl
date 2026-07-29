/* ISO bracketed comments may
   span multiple lines. */
query(answer(X0, X1, X2, X3, X4, X5, X6, X7, X8)).
answer(Binary, Octal, Hex, Character, Escaped, Curly, EmptyCurly, IntegerPart, FractionalPart) :-
    =(Binary, 0b101010),
    =(Octal, 0o52),
    =(Hex, 0x2a),
    =(Character, 0'\n),
    =(Escaped, 'A\x42\\101\'),
    =(Curly, {pair(a, b)}),
    =(EmptyCurly, {}),
    IntegerPart is float_integer_part(-3.75),
    FractionalPart is float_fractional_part(-3.75).
