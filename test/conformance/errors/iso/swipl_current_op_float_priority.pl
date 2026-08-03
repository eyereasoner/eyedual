% Adapted from SWI-Prolog tests/core/test_op.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: bad

bad :- current_op(1.2, _, _).
