% Explicit integrity-check example.
%
% Integrity conditions are ordinary predicates. A host that requires validated
% input queries invalid_state/2 before it trusts domain conclusions.

%% goal: invalid_state(X, Reason)
%% goal: status(X, Value)

color(stone, black).
color(stone, white).

invalid_state(X, conflicting_colors) :-
  color(X, black),
  color(X, white).

status(X, invalid(Reason)) :- invalid_state(X, Reason).
status(X, consistent) :- color(X, _), \+ invalid_state(X, _).
