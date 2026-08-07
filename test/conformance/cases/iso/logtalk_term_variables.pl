% Adapted from Logtalk iso_term_variables_2_03, 04, 06, 07, and 08.
% Modified for EyeProlog's conformance harness. See test/conformance/THIRD_PARTY.md.
%% goal: ground_variables(X0)

ground_variables(Ground) :- term_variables(t, Ground).

%% goal: ordered_variables(X0)

ordered_variables(Ordered) :-
    term_variables(A+B*C/B-D, Ordered),
    A = first,
    B = second,
    C = third,
    D = fourth.

%% goal: shared_variables_first(X0)

shared_variables_first(SharedFirst) :-
    S1 = B1+T1,
    T1 = A1*B1,
    term_variables(S1, SharedFirst),
    B1 = first,
    A1 = second.

%% goal: shared_variables_second(X0)

shared_variables_second(SharedSecond) :-
    T2 = A2*B2,
    S2 = B2+T2,
    term_variables(S2, SharedSecond),
    B2 = first,
    A2 = second.

%% goal: prefilled_variables

prefilled_variables :-
    term_variables(A3+B3+B3, [B3, B3]),
    A3 == B3.
