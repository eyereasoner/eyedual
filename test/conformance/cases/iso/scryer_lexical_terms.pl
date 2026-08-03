% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl.
% Upstream cases: 95, 101, 108, 124, 174, 175, 176, 186, 187,
% 219, 269, 298, and 302. See test/conformance/THIRD_PARTY.md.

%% goal: scryer_escapes(ok)

scryer_escapes(ok) :-
    a = '\141\',
    a = '\x61\',
    65 = 0'\x41\,
    atom_codes('\b\r\f\t\n', [8, 13, 12, 9, 10]).

%% goal: scryer_numbers(-1, 1, 1, 1, 1)

scryer_numbers(NegativeHex, Binary, Octal, Hex, Modulo) :-
    NegativeHex = -0x1,
    Binary = 0b1,
    Octal = 0o1,
    Hex = 0x1,
    Modulo is 0b1 mod 2.

%% goal: scryer_comments(7, 7)

scryer_comments(First, Second) :-
    First/* /*/=7,
    Second/*/*/=7.

%% goal: scryer_terms({1}, [a], [a, b | c], [])

scryer_terms(Curly, Proper, Improper, Empty) :-
    Curly = {1},
    Proper = [a|[]],
    Improper = [a,b|c],
    Empty = '[]'.
