% Annotation with quoted formula data.
%
% The program keeps the annotation as data and derives visible relations from it.
% Context members become default output only when explicit rules project them.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: name(X0, X1)

%% goal: log_nameOf(X0, X1)

%% goal: statedBy(X0, X1)

%% goal: recorded(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
annotation(t, (
  name(a, "Alice"),
  statedBy(t, bob),
  recorded(t, "2021-07-07")
)).

context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
name(S, O) :-
  annotation(_t, Context),
  context_member(Context, name(S, O)).

log_nameOf(T, name(S, O)) :-
  annotation(T, Context),
  context_member(Context, name(S, O)).

statedBy(S, O) :-
  annotation(_t, Context),
  context_member(Context, statedBy(S, O)).

recorded(S, O) :-
  annotation(_t, Context),
  context_member(Context, recorded(S, O)).
