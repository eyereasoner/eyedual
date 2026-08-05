% Source policy: examples/input/odrl-policy-advanced.ttl
% Regenerate with:
% node tools/rdf-to-eyedual.mjs --rules examples/input/odrl-policy-advanced-rules.pl examples/input/odrl-policy-advanced.ttl -o examples/odrl-policy-advanced-from-turtle.pl
%
% One policy is evaluated against three requests. The report demonstrates a
% constrained permission with a duty, a failed purpose constraint, and an
% explicit prohibition.
%% goal: advanced_odrl_report(_)

request(research_use, research_hospital, use, health_dataset, medical_research, eu).
request(commercial_use, research_hospital, use, health_dataset, commercial, eu).
request(dataset_transfer, research_hospital, transfer, health_dataset, medical_research, eu).

advanced_odrl_report([Research, Commercial, Transfer]) :-
  policy_decision(research_use, Research),
  policy_decision(commercial_use, Commercial),
  policy_decision(dataset_transfer, Transfer).

policy_decision(Request, decision(Request, permit, [duty(DutyAction)])) :-
  permitted(Request, DutyAction).
policy_decision(Request, decision(Request, deny, [reason(purpose_mismatch)])) :-
  purpose_mismatch(Request).
policy_decision(Request, decision(Request, deny, [reason(prohibited)])) :-
  prohibited(Request).

permitted(Request, DutyAction) :-
  request(Request, Assignee, Action, Target, Purpose, Region),
  rdf_link(advanced_policy, permission, Permission),
  rule_scope(Permission, Assignee, Action, Target),
  constraint_eq(Permission, purpose, Purpose),
  constraint_eq(Permission, spatial, Region),
  rdf_link(Permission, duty, Duty),
  rdf_link(Duty, action, DutyAction).

purpose_mismatch(Request) :-
  request(Request, Assignee, Action, Target, Purpose, Region),
  rdf_link(advanced_policy, permission, Permission),
  rule_scope(Permission, Assignee, Action, Target),
  constraint_eq(Permission, spatial, Region),
  constraint_eq(Permission, purpose, RequiredPurpose),
  Purpose \= RequiredPurpose.

prohibited(Request) :-
  request(Request, Assignee, Action, Target, _Purpose, _Region),
  rdf_link(advanced_policy, prohibition, Prohibition),
  rule_scope(Prohibition, Assignee, Action, Target).

rule_scope(Rule, Assignee, Action, Target) :-
  rdf_link(Rule, assignee, Assignee),
  rdf_link(Rule, action, Action),
  rdf_link(Rule, target, Target).

constraint_eq(Rule, LeftOperand, RightOperand) :-
  rdf_link(Rule, constraint, Constraint),
  rdf_link(Constraint, left_operand, LeftOperand),
  rdf_link(Constraint, operator, eq),
  rdf_link(Constraint, right_operand, RightOperand).

rdf_link(Subject, Predicate, Object) :-
  iri_value(Subject, SubjectIri),
  iri_value(Predicate, PredicateIri),
  iri_value(Object, ObjectIri),
  rdf(iri(SubjectIri), iri(PredicateIri), iri(ObjectIri), default_graph).

iri_value(advanced_policy, "https://example.org/advanced-policy").
iri_value(research_permission, "https://example.org/research-permission").
iri_value(transfer_prohibition, "https://example.org/transfer-prohibition").
iri_value(health_dataset, "https://example.org/health-dataset").
iri_value(research_hospital, "https://example.org/research-hospital").
iri_value(medical_research, "https://example.org/medical-research").
iri_value(eu, "https://example.org/eu").
iri_value(deidentify_duty, "https://example.org/deidentify-duty").
iri_value(deidentify, "https://example.org/deidentify").
iri_value(purpose_constraint, "https://example.org/purpose-constraint").
iri_value(region_constraint, "https://example.org/region-constraint").
iri_value(permission, "http://www.w3.org/ns/odrl/2/permission").
iri_value(prohibition, "http://www.w3.org/ns/odrl/2/prohibition").
iri_value(target, "http://www.w3.org/ns/odrl/2/target").
iri_value(action, "http://www.w3.org/ns/odrl/2/action").
iri_value(assignee, "http://www.w3.org/ns/odrl/2/assignee").
iri_value(constraint, "http://www.w3.org/ns/odrl/2/constraint").
iri_value(duty, "http://www.w3.org/ns/odrl/2/duty").
iri_value(left_operand, "http://www.w3.org/ns/odrl/2/leftOperand").
iri_value(operator, "http://www.w3.org/ns/odrl/2/operator").
iri_value(right_operand, "http://www.w3.org/ns/odrl/2/rightOperand").
iri_value(purpose, "http://www.w3.org/ns/odrl/2/purpose").
iri_value(spatial, "http://www.w3.org/ns/odrl/2/spatial").
iri_value(eq, "http://www.w3.org/ns/odrl/2/eq").
iri_value(use, "http://www.w3.org/ns/odrl/2/use").
iri_value(transfer, "http://www.w3.org/ns/odrl/2/transfer").
