% Adapted from Logtalk iso_sub_atom_5_01 through 07 and sics_sub_atom_5_17
% through 28 and 33. Modified for EyeProlog's harness. See THIRD_PARTY.md.
%% goal: sub_atom_results(X0, X1, X2, X3)

sub_atom_results(Prefix, Suffix, Middle, Occurrences) :-
    sub_atom(abracadabra, 0, 5, _, Prefix),
    sub_atom(abracadabra, _, 5, 0, Suffix),
    sub_atom(abracadabra, 3, 5, 3, Middle),
    findall(B-A, sub_atom(abracadabra, B, 2, A, ab), Occurrences),
    sub_atom('Banana', 2, 3, 1, nan),
    \+ sub_atom('Banana', 2, 3, 1, ana),
    \+ sub_atom('Banana', 2, 3, 2, nan),
    \+ sub_atom('Banana', 0, 7, 0, _).
