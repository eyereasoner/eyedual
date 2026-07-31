% Adapted from Scryer ISO conformity test 93.
% See test/conformance/THIRD_PARTY.md.
query(bad).
bad :- [a,b|,] = [a, b].
