% Adapted from Logtalk iso_atom_length_2_01 through 04.
% Modified for Eyepl's conformance harness. See test/conformance/THIRD_PARTY.md.
query(atom_lengths(X0, X1)).
atom_lengths(Phrase, Empty) :-
    atom_length('enchanted evening', Phrase),
    atom_length('', Empty),
    \+ atom_length(scarlet, 5).
