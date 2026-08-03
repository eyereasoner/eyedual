% Adapted from SWI-Prolog tests/core/test_op.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: bad

bad :- current_op(_, 1, _).
