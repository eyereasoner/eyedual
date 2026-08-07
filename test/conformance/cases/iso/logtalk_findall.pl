% Adapted from Logtalk iso_findall_3_01 through 06 and lgt_findall_3_12.
% Modified for EyeProlog's conformance harness. See test/conformance/THIRD_PARTY.md.
%% goal: findall_results(X0, X1, X2, X3)

findall_results(Ordered, Empty, Duplicates, Bound) :-
    findall(X, (X = 1; X = 2), Ordered),
    findall(_, fail, Empty),
    findall(Y, (Y = 1; Y = 1), Duplicates),
    \+ findall(Z, (Z = 2; Z = 1), [1, 2]),
    findall(W, (W = 1; W = 2), [First, Second]),
    Bound = First-Second,
    First = 1,
    Second = 2.
