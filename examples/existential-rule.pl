% Existential-style introduction with explicit Herbrand witnesses.
%
% EyeProlog has no blank nodes and no existential variables in rule heads.  A
% rule can still express the practical executable shape of an existential
% consequence by putting a named functional term directly in the head.

%% goal: holds_result(X0, X1)


type(socrates, human).
type(plato, human).

% In proof output this rule is the step that explains each visible witness.
holds_result(Person, human_witness(Person)) :-
  type(Person, human).
