% Adapted from Logtalk iso_atom_chars_2_01 through 07 and
% lgt_atom_chars_2_17 through 22, 26, and 27. Modified for EyeProlog's harness.
% See test/conformance/THIRD_PARTY.md.
%% goal: atom_chars_results(X0, X1, X2, X3)

atom_chars_results(Empty, Brackets, Ant, Built) :-
    atom_chars('', Empty),
    atom_chars([], Brackets),
    atom_chars(ant, Ant),
    atom_chars(Built, [s, o, p]),
    atom_chars('North', ['N' | Rest]),
    Rest = [o, r, t, h],
    \+ atom_chars(soap, [s, o, p]),
    atom_chars('ABC', [A, B, C]),
    A = 'A', B = 'B', C = 'C',
    \+ atom_chars('ABC', ['B' | _]),
    atom_chars('ABC', ['A', 'B', 'C' | Tail]),
    Tail = [],
    \+ atom_chars(a, [_, _]).
