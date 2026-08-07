% Adapted from Logtalk iso_atom_length_2_01 through 04.
% Modified for EyeProlog's conformance harness. See test/conformance/THIRD_PARTY.md.
%% goal: atom_lengths(X0, X1)

atom_lengths(Phrase, Empty) :-
    atom_length('enchanted evening', Phrase),
    atom_length('', Empty),
    \+ atom_length(scarlet, 5).
