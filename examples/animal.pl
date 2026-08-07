% Animal classification, adapted from Eyelet's input/animal.pl.
%
% The Eyelet source uses Unicode predicate names; this eyeprolog version keeps the
% same tiny inheritance idea with plain vocabulary names.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: type(X0, X1)

%% goal: subclassOf(X0, X1)

%% goal: succeeds(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
human(joe).
animal(human).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
animal(X) :- human(X).

type(joe, human) :- human(joe).
type(joe, animal) :- animal(joe).
subclassOf(human, animal) :- animal(human).
succeeds(animalExample, true) :- animal(_).
