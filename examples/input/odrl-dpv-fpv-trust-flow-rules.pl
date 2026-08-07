% Source data: examples/input/odrl-dpv-fpv-trust-flow.ttl
% Regenerate with:
% node tools/rdf-to-pl.mjs --rules examples/input/odrl-dpv-fpv-trust-flow-rules.pl examples/input/odrl-dpv-fpv-trust-flow.ttl -o examples/odrl-dpv-fpv-trust-flow.pl
%
% ODRL policy rules, trust scores, and requested flows are RDF data. The rules
% produce one deterministic FPV-style decision report.
%% goal: trust_flow_report(_)

trust_flow_report([Care, Clinic, Ads]) :-
  flow_decision(flow_care, Care),
  flow_decision(flow_clinic, Clinic),
  flow_decision(flow_ads, Ads).

flow_decision(Flow, decision(Flow, permit, confidence(Score), status(executable_flow))) :-
  permitted_flow(Flow, Score).
flow_decision(Flow, decision(Flow, review, confidence(Score), risk(trustworthiness_risk))) :-
  review_flow(Flow, Score).
flow_decision(Flow, decision(Flow, deny, status(blocked_flow), risk(unwanted_disclosure))) :-
  prohibited_flow(Flow).

permitted_flow(Flow, Score) :-
  flow_request(Flow, Source, Recipient, Data, Action, Purpose),
  policy_rule(odrl(permission), Rule, Recipient, Data, Action, Purpose),
  rdf_number(Rule, ex(minTrust), Minimum),
  rdf_number(Source, ex(trustScore), Score),
  Score >= Minimum.

review_flow(Flow, Score) :-
  flow_request(Flow, Source, Recipient, Data, Action, Purpose),
  policy_rule(odrl(permission), Rule, Recipient, Data, Action, Purpose),
  rdf_number(Rule, ex(minTrust), Minimum),
  rdf_number(Source, ex(trustScore), Score),
  Score < Minimum.

prohibited_flow(Flow) :-
  flow_request(Flow, _Source, Recipient, Data, Action, Purpose),
  policy_rule(odrl(prohibition), _Rule, Recipient, Data, Action, Purpose).

flow_request(Flow, Source, Recipient, Data, Action, Purpose) :-
  flow_resource(Flow, Resource),
  rdf_link(Resource, ex(source), Source),
  rdf_link(Resource, ex(recipient), Recipient),
  rdf_link(Resource, ex(data), Data),
  rdf_link(Resource, ex(requestedAction), Action),
  rdf_link(Resource, ex(requestedPurpose), Purpose).

policy_rule(Type, Rule, Recipient, Data, Action, Purpose) :-
  rdf_link(ex('trust-policy'), Type, Rule),
  rdf_link(Rule, odrl(assignee), Recipient),
  rdf_link(Rule, odrl(target), Data),
  rdf_link(Rule, odrl(action), Action),
  rdf_link(Rule, odrl(purpose), Purpose).

flow_resource(flow_care, ex('flow-care')).
flow_resource(flow_clinic, ex('flow-clinic')).
flow_resource(flow_ads, ex('flow-ads')).

rdf_link(Subject, Predicate, Object) :-
  iri_term(Subject, SubjectIri),
  iri_term(Predicate, PredicateIri),
  rdf(iri(SubjectIri), iri(PredicateIri), iri(ObjectIri), default_graph),
  iri_term(Object, ObjectIri).

rdf_number(Subject, Predicate, Number) :-
  iri_term(Subject, SubjectIri),
  iri_term(Predicate, PredicateIri),
  rdf(iri(SubjectIri), iri(PredicateIri), literal(Text, datatype(_Datatype)), default_graph),
  number_string(Number, Text).

iri_term(ex(Name), Iri) :- namespace_iri('https://example.org/', Name, Iri).
iri_term(odrl(Name), Iri) :- namespace_iri('http://www.w3.org/ns/odrl/2/', Name, Iri).

namespace_iri(Prefix, Name, Iri) :-
  atom(Name),
  !,
  atom_string(Name, Local),
  string_concat(Prefix, Local, Iri).
namespace_iri(Prefix, Name, Iri) :-
  string_concat(Prefix, Local, Iri),
  atom_string(Name, Local).
