% Nixon diamond: two independent defaults support incompatible conclusions.
% This mirrors the classic EYE reasoning theme while keeping the conclusion explicit:
% a subject with both defaults is reported as conflicted rather than forced to
% choose one extension.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: defaultSupports(X0, X1)

%% goal: conflict(X0, X1)

%% goal: status(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
kind(nixon, quaker).
kind(nixon, republican).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
supports_default(Person, pacifist) :-
  kind(Person, quaker).

supports_default(Person, hawk) :-
  kind(Person, republican).

contrary(pacifist, hawk).
contrary(hawk, pacifist).

conflicted(Person, A, B) :-
  supports_default(Person, A),
  supports_default(Person, B),
  contrary(A, B).

defaultSupports(Person, Conclusion) :-
  supports_default(Person, Conclusion).

conflict(Person, conflict(A, B)) :-
  conflicted(Person, A, B).

status(Person, conflicted_default_case) :-
  conflicted(Person, _a, _b).
