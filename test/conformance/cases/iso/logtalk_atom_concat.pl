% Adapted from Logtalk iso_atom_concat_3_01 through 04 and
% lgt_atom_concat_3_15 through 20. Modified for EyeProlog's conformance harness.
% See test/conformance/THIRD_PARTY.md.
%% goal: atom_concat_results(X0, X1, X2, X3)

atom_concat_results(Joined, Prefix, Splits, EmptyPair) :-
    atom_concat(hello, ' world', Joined),
    atom_concat(Prefix, ' world', 'small world'),
    \+ atom_concat(hello, ' world', 'small world'),
    findall(A-B, atom_concat(A, B, hello), Splits),
    atom_concat('', '.', '.'),
    atom_concat('.', '', '.'),
    atom_concat(a, b, ab),
    \+ atom_concat(a, _, bc),
    \+ atom_concat(_, b, cd),
    atom_concat(EmptyA, EmptyB, ''),
    EmptyPair = EmptyA-EmptyB.
