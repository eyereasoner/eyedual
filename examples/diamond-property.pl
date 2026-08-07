% Diamond property, adapted from Eyelet's input/diamond-property.pl.
%
% A relation has the diamond property when two outgoing steps from the same
% source can be joined again.  This compact eyeprolog version keeps the same
% diamond idea and also checks that it is preserved by reflexive closure.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: holdsFor(X0, X1)

%% goal: commonSuccessor(X0, X1)

%% goal: preservedUnderReflexiveClosure(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
node(a).
node(b).
node(c).
node(d).

r(a, b).
r(a, c).
r(b, d).
r(c, d).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
re(X, X) :- node(X).
re(X, Y) :- r(X, Y).

diamond(Rel, A, B, C, D) :-
  step(Rel, A, B),
  step(Rel, A, C),
  step(Rel, B, D),
  step(Rel, C, D).

step(r, X, Y) :- r(X, Y).
step(re, X, Y) :- re(X, Y).

holdsFor(diamondProperty, Rel) :- diamond(Rel, a, b, c, d).
commonSuccessor(diamondProperty, D) :- diamond(r, a, b, c, D).
preservedUnderReflexiveClosure(diamondProperty, true) :- diamond(re, a, b, c, d).
