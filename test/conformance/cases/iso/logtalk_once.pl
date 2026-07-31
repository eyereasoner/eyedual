% Adapted from Logtalk iso_once_1_01 through 04.
% Modified for Eyepl's conformance harness. See test/conformance/THIRD_PARTY.md.
query(once_results(X0)).
once_results(Values) :-
    once(!),
    findall(X, choose_after_once(X), Values),
    once(repeat),
    \+ once(fail).

choose_after_once(X) :- once(!), (X = 1; X = 2).
