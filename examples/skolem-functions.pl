% Skolem functional terms in rule heads.
%
% A generated resource should be deterministic and collision-free. Use a
% function symbol whose arguments contain the values that make the resource
% unique, such as skolem_observation(Patient, Test).

% Output declarations: query/1 selects the relations written to this example's golden output.
query(type(X0, X1)).
query(patient(X0, X1)).
query(test(X0, X1)).
query(value(X0, X1)).
query(about(X0, X1)).
query(sameInputsSameId(X0, X1)).
query(noObservationClash(X0, X1)).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.
test_result(alice, glucose, 6.8).
test_result(alice, cholesterol, 4.2).
test_result(bob, glucose, 5.1).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
high_glucose(Patient) :-
  test_result(Patient, glucose, Value),
  (Value > 6.0).

observation_id(Patient, Test, skolem_observation(Patient, Test)) :-
  test_result(Patient, Test, _value).

type(skolem_observation(Patient, Test), observation) :-
  test_result(Patient, Test, _value).

patient(skolem_observation(Patient, Test), Patient) :-
  test_result(Patient, Test, _value).

test(skolem_observation(Patient, Test), Test) :-
  test_result(Patient, Test, _value).

value(skolem_observation(Patient, Test), Value) :-
  test_result(Patient, Test, Value).

type(skolem_alert(Patient, glucose), highGlucoseAlert) :-
  high_glucose(Patient).

about(skolem_alert(Patient, glucose), skolem_observation(Patient, glucose)) :-
  high_glucose(Patient).

sameInputsSameId(skolemDemo, true) :-
  (skolem_observation(alice, glucose) = skolem_observation(alice, glucose)).

noObservationClash(skolemDemo, true) :-
  (skolem_observation(alice, glucose) \= skolem_observation(alice, cholesterol)),
  (skolem_observation(alice, glucose) \= skolem_observation(bob, glucose)).
