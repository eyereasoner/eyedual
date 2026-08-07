% =============================================================================================================================
% Deep Taxonomy - depth 10 - expanded N3-style eyeprolog
%
% Adjacent rules mirror the Eyeling N3 deep-taxonomy chain. Each step derives
% the next taxonomy class together with two side labels.
% =============================================================================================================================

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: holds_result(X0, X1)

%% goal: answer(X0, X1)

%% goal: reason(X0, X1)

%% goal: result(X0, X1)

%% goal: checkPassed(X0, X1)

%% goal: arc(X0, X1)


:- discontiguous(a/2).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.
% fact

a(ind, n0).

% terminal rule

% Derivation rules: each rule below contributes one logical step toward the displayed results.
holds_result(test, true) :- once(a(ind, a2)).
a(X, a2) :- a(X, n10).

% Adjacent N3-style taxonomy rules.

a(X, n1) :- a(X, n0).
a(X, i1) :- a(X, n0).
a(X, j1) :- a(X, n0).
a(X, n2) :- a(X, n1).
a(X, i2) :- a(X, n1).
a(X, j2) :- a(X, n1).
a(X, n3) :- a(X, n2).
a(X, i3) :- a(X, n2).
a(X, j3) :- a(X, n2).
a(X, n4) :- a(X, n3).
a(X, i4) :- a(X, n3).
a(X, j4) :- a(X, n3).
a(X, n5) :- a(X, n4).
a(X, i5) :- a(X, n4).
a(X, j5) :- a(X, n4).
a(X, n6) :- a(X, n5).
a(X, i6) :- a(X, n5).
a(X, j6) :- a(X, n5).
a(X, n7) :- a(X, n6).
a(X, i7) :- a(X, n6).
a(X, j7) :- a(X, n6).
a(X, n8) :- a(X, n7).
a(X, i8) :- a(X, n7).
a(X, j8) :- a(X, n7).
a(X, n9) :- a(X, n8).
a(X, i9) :- a(X, n8).
a(X, j9) :- a(X, n8).
a(X, n10) :- a(X, n9).
a(X, i10) :- a(X, n9).
a(X, j10) :- a(X, n9).

% ARC checks

arc(check1, "C1 OK - the starting classification n0 is present.") :-
 once(a(ind, n0)).

arc(check2, "C2 OK - the first expansion produced n1 together with side labels i1 and j1.") :-
 once(a(ind, n1)),
 once(a(ind, i1)),
 once(a(ind, j1)).

arc(check3, "C3 OK - the chain reaches the midpoint n5 and still carries both side-label branches.") :-
 once(a(ind, n5)),
 once(a(ind, i5)),
 once(a(ind, j5)).

arc(check4, "C4 OK - the final taxonomy step from n9 to n10 was completed.") :-
 once(a(ind, n9)),
 once(a(ind, n10)).

arc(check5, "C5 OK - once n10 is reached, the terminal class a2 is derived.") :-
 once(a(ind, n10)),
 once(a(ind, a2)).

arc(check6, "C6 OK - the success flag is raised only after the terminal class a2 is present.") :-
 once(a(ind, a2)),
 once(holds_result(test, true)).

% ARC report

answer(report, "The test succeeds: starting from one individual classified as n0, the rules eventually classify it as n10 and then as a2.") :-
 once(holds_result(test, true)).

reason(report, "The adjacent rules mirror the Eyeling N3 deep-taxonomy-10 chain: each rule advances one taxonomy level and adds the matching side labels.") :-
 once(a(ind, a2)),
 once(holds_result(test, true)).

checkPassed(report, Check) :-
 arc(Check, _message).

result(report, success) :-
 once(holds_result(test, true)),
 once(arc(check1, _c1)),
 once(arc(check2, _c2)),
 once(arc(check3, _c3)),
 once(arc(check4, _c4)),
 once(arc(check5, _c5)),
 once(arc(check6, _c6)).
