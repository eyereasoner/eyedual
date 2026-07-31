% Adapted from SWI-Prolog tests/core/test_op.pl.
% See test/conformance/THIRD_PARTY.md.
query(bad).
bad :- current_op(_, xxx, _).
