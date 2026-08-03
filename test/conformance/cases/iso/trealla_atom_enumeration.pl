% Adapted from Trealla Prolog tests/tests/test018.pl and test100.pl.
% See test/conformance/THIRD_PARTY.md.

%% goal: concat_split(Left, Right)

concat_split(Left, Right) :-
    atom_concat(Left, Right, abcdef).

%% goal: sub_atom_match(Before, Length, After)

sub_atom_match(Before, Length, After) :-
    sub_atom(banana, Before, Length, After, ana).
