% Adapted from Scryer ISO conformity test 74.
% See test/conformance/THIRD_PARTY.md.
query(bad).
bad :- [a|b|c] = [a].
