% Adapted from Logtalk iso_atom_codes_2_01 through 07 and
% lgt_atom_codes_2_15 through 20, 24, and 25. Modified for EyeProlog's harness.
% See test/conformance/THIRD_PARTY.md.
%% goal: atom_codes_results(X0, X1, X2, X3)

atom_codes_results(Empty, Brackets, Ant, Built) :-
    atom_codes('', Empty),
    atom_codes([], Brackets),
    atom_codes(ant, Ant),
    atom_codes(Built, [115, 111, 112]),
    atom_codes('North', [78 | Rest]),
    Rest = [111, 114, 116, 104],
    \+ atom_codes(soap, [115, 111, 112]),
    atom_codes('ABC', [A, B, C]),
    A = 65, B = 66, C = 67,
    \+ atom_codes('ABC', [66 | _]),
    atom_codes('ABC', [65, 66, 67 | Tail]),
    Tail = [],
    \+ atom_codes(a, [_, _]).
