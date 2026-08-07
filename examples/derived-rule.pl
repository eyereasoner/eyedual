% Derived rule example adapted from Eyeling derived-rule.n3.
%
% Eyeling source shape:
%   minka a cat.
%   charly a dog.
%   { X a cat. } => { { Y a dog. } => { test is true. }. }.
%
% The inner implication is represented directly as quoted formula data.
% var(y) is not a eyeprolog variable; it is a ground term that names
% a variable placeholder inside the quoted formula.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: type(X0, X1)

%% goal: log_implies(X0, X1)

%% goal: holds_result(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
type(minka, cat).
type(charly, dog).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
log_implies(type(var(y), dog), holds_result(test, true)) :-
  type(_x, cat).

holds_result(test, true) :-
  log_implies(type(var(y), dog), holds_result(test, true)),
  type(_y, dog).
