% Memoize scoped family projection and recursive labels; cousin derivation asks
% for the same generation and branch facts many times.
% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: generation(X0, X1)

%% goal: branch(X0, X1)

%% goal: cousin(X0, X1)


:- discontiguous(branch/2).

% The family tree is scoped inside family_graph/2.  family_statement/3 projects
% only the parent and seedBranch facts that the cousin rules need.

% Family-cousins derivation adapted from Eyeling family-cousins.n3.
% Generation numbers are derived from parent links; branch labels distinguish
% descendants of Bob from descendants of Carol.
% The family tree and seed branch labels are quoted as a small formula term, so
% the rules derive from scoped family data rather than global relationship facts.

family_graph(familyGraph, (
  parent(adam, bob),
  parent(adam, carol),
  parent(bob, dave),
  parent(bob, eve),
  parent(carol, frank),
  parent(carol, grace),
  parent(dave, heidi),
  parent(eve, ivan),
  parent(frank, judy),
  seedBranch(dave, b),
  seedBranch(eve, b),
  seedBranch(frank, c),
  seedBranch(grace, c)
)).

% generation/2 walks parent links from Adam, branch/2 propagates seed labels,
% and cousin/2 combines equal generation with different branches.
context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).

family_statement(S, P, O) :-
  family_graph(familyGraph, Context),
  context_member(Context, Statement),
  (Statement =.. [P, S, O]).

parent(Parent, Child) :- family_statement(Parent, parent, Child).
branch(Person, Branch) :- family_statement(Person, seedBranch, Branch).

different(b, c).
different(c, b).

generation(adam, 0).
generation(Child, Next) :-
  parent(Parent, Child),
  generation(Parent, Gen),
  (Next is Gen + 1).

branch(Child, Branch) :-
  parent(Parent, Child),
  branch(Parent, Branch).

derived_branch(Child, Branch) :-
  parent(Parent, Child),
  branch(Parent, Branch).

cousin(X, Y) :-
  generation(X, Gen),
  generation(Y, Gen),
  branch(X, Bx),
  branch(Y, By),
  different(Bx, By).

branch(Person, Branch) :- derived_branch(Person, Branch).
