% Adapted from Logtalk iso_setof_3_01 through 09.
% Modified for EyeProlog's conformance harness. See test/conformance/THIRD_PARTY.md.
%% goal: setof_results(X0, X1, X2)

setof_results(Ordered, Unique, Quantified) :-
    setof(X, (X = 2; X = 1), Ordered),
    setof(Y, (Y = 2; Y = 2), Unique),
    setof(Z, W^(pair(Z, W)), Quantified),
    \+ setof(_, fail, _).
pair(2, b). pair(1, a).
