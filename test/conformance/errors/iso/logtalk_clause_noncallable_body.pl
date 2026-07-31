% Adapted from Logtalk eddbali_clause_2_12. Modified for Eyepl's harness.
% See test/conformance/THIRD_PARTY.md.
:- dynamic(f/1).
f(a).
query(clause(f(_), 5)).
