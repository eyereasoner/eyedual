% Adapted from Logtalk iso_clause_2_01 through 06.
% Modified for EyeProlog's conformance harness. See test/conformance/THIRD_PARTY.md.
:- dynamic(insect/1).
insect(ant). insect(bee).
:- dynamic(legs/2).
legs(A, 6) :- insect(A).
%% goal: clause_results(X0, X1)

clause_results(Body, Clauses) :-
    clause(legs(I, 6), Body),
    I = ant,
    findall(X-T, clause(insect(X), T), Clauses),
    \+ clause(missing, _).
