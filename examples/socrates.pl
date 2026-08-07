% Socrates is mortal, adapted from Eyelet's input/socrates.pl.
%
% Eyelet uses type('Socrates', 'Man') and a single rule deriving Mortal.
% eyeprolog keeps the same reasoning shape and emits relation facts.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: type(X0, X1)

%% goal: holds_result(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
type(socrates, man).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
type(X, mortal) :-
  type(X, man).


holds_result(test, true) :-
  type(socrates, mortal).
