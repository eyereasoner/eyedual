% Source data: examples/input/odrl-dpv-healthcare-risk-ranked.ttl
% Regenerate with:
% node tools/rdf-to-pl.mjs --rules examples/input/odrl-dpv-healthcare-risk-ranked-rules.pl examples/input/odrl-dpv-healthcare-risk-ranked.ttl -o examples/odrl-dpv-healthcare-risk-ranked.pl
%
% ODRL permissions and DPV-style risk profiles are RDF data. The rules detect
% missing safeguards, score the risks, and return one deterministic ranking.
%% goal: healthcare_risk_report(_)

healthcare_risk_report(Ranked) :-
  findall(
    key(InverseScore, Clause)-dpv_risk(Risk, Score, Level, Clause, Mitigation),
    (
      risk_report(Risk, Score, Level, Clause, Mitigation),
      InverseScore is 1000 - Score
    ),
    Unsorted
  ),
  sort(Unsorted, Sorted),
  ranked_values(Sorted, 1, Ranked).

risk_report(Risk, Score, Level, Clause, Mitigation) :-
  risk_profile(_Profile, Risk, Rule, Need, Base, Mitigation),
  risk_triggered(Risk, Rule, Need),
  rdf_text(Rule, ex(clause), ClauseText),
  atom_string(Clause, ClauseText),
  rdf_number(Need, ex(importance), Importance),
  Raw is Base + Importance,
  (Raw > 100 -> Score = 100 ; Score = Raw),
  risk_level(Score, Level).

risk_profile(Profile, Risk, Rule, Need, Base, Mitigation) :-
  rdf_link(ex('healthcare-policy'), ex(riskProfile), Profile),
  rdf_link(Profile, ex(risk), RiskResource),
  risk_resource(Risk, RiskResource),
  rdf_link(Profile, ex(policyRule), Rule),
  rdf_link(Profile, ex(need), Need),
  rdf_number(Profile, ex(baseScore), Base),
  rdf_link(Profile, ex(mitigation), MitigationResource),
  mitigation_resource(Mitigation, MitigationResource).

risk_triggered(consent_risk, Rule, _Need) :-
  rdf_link(ex('healthcare-policy'), odrl(permission), Rule),
  rdf_link(Rule, odrl(action), odrl(use)),
  \+ constraint_text(Rule, ex(explicitConsent), "true").

risk_triggered(sharing_risk, Rule, _Need) :-
  rdf_link(ex('healthcare-policy'), odrl(permission), Rule),
  rdf_link(Rule, odrl(action), ex(disclose)),
  rdf_link(Rule, odrl(target), ex('genomic-data')),
  \+ constraint_text(Rule, ex(deidentified), "true").

risk_triggered(retention_risk, Rule, Need) :-
  rdf_link(ex('healthcare-policy'), odrl(permission), Rule),
  constraint_number(Rule, ex(retentionDays), Days),
  rdf_number(Need, ex(maximumDays), Maximum),
  Days > Maximum.

constraint_text(Rule, LeftOperand, Value) :-
  rdf_link(Rule, odrl(constraint), Constraint),
  rdf_link(Constraint, odrl('leftOperand'), LeftOperand),
  rdf_link(Constraint, odrl(operator), odrl(eq)),
  rdf_text(Constraint, odrl('rightOperand'), Value).

constraint_number(Rule, LeftOperand, Number) :-
  constraint_text(Rule, LeftOperand, Text),
  number_string(Number, Text).

risk_level(Score, high) :- Score > 79.
risk_level(Score, moderate) :- Score > 49, Score < 80.

ranked_values([], _Rank, []).
ranked_values([_Key-Risk|Rest], Rank, [rank(Rank, Risk)|Ranked]) :-
  NextRank is Rank + 1,
  ranked_values(Rest, NextRank, Ranked).

risk_resource(consent_risk, ex('consent-risk')).
risk_resource(sharing_risk, ex('sharing-risk')).
risk_resource(retention_risk, ex('retention-risk')).

mitigation_resource(require_explicit_consent, ex('require-explicit-consent')).
mitigation_resource(require_deidentification, ex('require-deidentification')).
mitigation_resource(limit_retention_to_1095_days, ex('limit-retention-to-1095-days')).

rdf_link(Subject, Predicate, Object) :-
  iri_term(Subject, SubjectIri),
  iri_term(Predicate, PredicateIri),
  rdf(iri(SubjectIri), iri(PredicateIri), iri(ObjectIri), default_graph),
  iri_term(Object, ObjectIri).

rdf_text(Subject, Predicate, Text) :-
  iri_term(Subject, SubjectIri),
  iri_term(Predicate, PredicateIri),
  rdf(iri(SubjectIri), iri(PredicateIri), literal(Text, datatype(_Datatype)), default_graph).

rdf_number(Subject, Predicate, Number) :-
  rdf_text(Subject, Predicate, Text),
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
