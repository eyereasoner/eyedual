% Knowledge-engineering alignment flow in EyeProlog.
%
% The source graph uses local observation predicates.  The mapping facts below
% align those local names with small SOSA-like and FPV-like vocabulary atoms, then
% generic rules emit a target-shaped flow view.
%
% This demonstrates a common knowledge-engineering pattern: keep source data in
% its original shape, describe the alignment declaratively, and derive target facts
% without rewriting the original assertions.

%% goal: type(X0, X1)

%% goal: target_fact(X0, X1, X2)

%% goal: runtime_rule(X0, X1)

%% goal: target_predicate(X0, X1)

%% goal: flow_emits(X0, X1)

%% goal: trusted_by(X0, X1)


sub_class(local_observation, sosa_observation).
sub_class(temperature_probe, sosa_sensor).
sub_property(observed_by, sosa_madeBySensor).
sub_property(observed_at, sosa_resultTime).
sub_property(temperature_celsius, sosa_hasSimpleResult).
sub_property(in_flow, fpv_hasFlowStep).
equivalent_property(observed_feature, sosa_hasFeatureOfInterest).

type(msg1, local_observation).
type(probe7, temperature_probe).
triple(msg1, observed_by, probe7).
triple(msg1, observed_at, "2026-06-17T12:34:56Z").
triple(msg1, temperature_celsius, 18.6).
triple(msg1, observed_feature, platform_b).
triple(msg1, in_flow, ingest_step).

% Generic alignment rules.
type(Thing, Super) :- type(Thing, Class), sub_class(Class, Super).
target_fact(Subject, Superpredicate, Object) :- triple(Subject, Predicate, Object), sub_property(Predicate, Superpredicate).
target_fact(Subject, Targetpredicate, Object) :- triple(Subject, Predicate, Object), equivalent_property(Predicate, Targetpredicate).
target_fact(Subject, Sourcepredicate, Object) :- triple(Subject, Predicate, Object), equivalent_property(Sourcepredicate, Predicate).

runtime_rule(Sourcepredicate, copy_to_target) :- sub_property(Sourcepredicate, _targetpredicate).
runtime_rule(Sourcepredicate, copy_to_target) :- equivalent_property(Sourcepredicate, _targetpredicate).
target_predicate(Sourcepredicate, Targetpredicate) :- sub_property(Sourcepredicate, Targetpredicate).
target_predicate(Sourcepredicate, Targetpredicate) :- equivalent_property(Sourcepredicate, Targetpredicate).

flow_emits(Step, Message) :- type(Message, sosa_observation), target_fact(Message, fpv_hasFlowStep, Step), target_fact(Message, sosa_madeBySensor, _sensor).
trusted_by(Step, Sensor) :- type(Message, sosa_observation), target_fact(Message, fpv_hasFlowStep, Step), target_fact(Message, sosa_madeBySensor, Sensor).
