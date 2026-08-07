% Burn the witch, adapted from Eyeling's examples/witch.n3.
%
% This is the classic N3/Semantic Web rule chain in eyeprolog form: a duck
% floats; something with the same weight as something that floats also floats;
% things that float are made of wood; things made of wood burn; and a woman
% who burns is a witch.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: floats(X0)

%% goal: madeOfWood(X0)

%% goal: burns(X0)

%% goal: witch(X0)

%% goal: holds_result(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
% Derivation rules: each rule below contributes one logical step toward the displayed results.
witch(X) :-
  burns(X),
  woman(X).

woman(girl).

burns(X) :-
  madeOfWood(X).

madeOfWood(X) :-
  floats(X).

floats(duck).

floats(Y) :-
  sameWeight(X, Y),
  floats(X).

sameWeight(duck, girl).

holds_result(witchExample, true) :-
  witch(girl).
