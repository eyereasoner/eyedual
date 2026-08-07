% Adapted from Logtalk iso_bagof_3_01 through 07 and 12.
% Modified for EyeProlog's conformance harness. See test/conformance/THIRD_PARTY.md.
b(1, 1). b(1, 1). b(1, 2). b(2, 1). b(2, 2). b(2, 2).
%% goal: bagof_results(X0, X1, X2)

bagof_results(Simple, Duplicates, Quantified) :-
    bagof(X, (X = 1; X = 2), Simple),
    bagof(Y, b(1, Y), Duplicates),
    bagof(Z, W^(pair(Z, W)), Quantified).
pair(1, a). pair(2, b).
