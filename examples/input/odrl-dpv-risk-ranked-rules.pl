% Source data: examples/input/odrl-dpv-risk-ranked.ttl
% Regenerate with:
% node tools/rdf-to-pl.mjs --rules examples/input/odrl-dpv-risk-ranked-rules.pl examples/input/odrl-dpv-risk-ranked.ttl -o examples/odrl-dpv-risk-ranked.pl
%
% ODRL agreement rules and DPV-style needs are RDF data. The rules derive one
% risk per conflict, score it, and return one deterministic ranking.
%% goal: consumer_risk_report(_)

consumer_risk_report(Ranked) :-
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
  rdf_link(ex('consumer-policy'), ex(riskProfile), Profile),
  rdf_link(Profile, ex(risk), RiskResource),
  risk_resource(Risk, RiskResource),
  rdf_link(Profile, ex(policyRule), Rule),
  rdf_link(Profile, ex(need), Need),
  rdf_number(Profile, ex(baseScore), Base),
  rdf_link(Profile, ex(mitigation), MitigationResource),
  mitigation_resource(Mitigation, MitigationResource).

risk_triggered(deletion_risk, Rule, _Need) :-
  rdf_link(ex('consumer-policy'), odrl(permission), Rule),
  rdf_link(Rule, odrl(action), ex('remove-account')),
  \+ duty_action(Rule, ex(inform)),
  \+ constraint_number(Rule, ex(noticeDays), _Days).

risk_triggered(terms_risk, Rule, Need) :-
  rdf_link(ex('consumer-policy'), odrl(permission), Rule),
  rdf_link(Rule, odrl(action), ex('change-terms-action')),
  duty_action(Rule, ex(inform)),
  constraint_number(Rule, ex(noticeDays), Days),
  rdf_number(Need, ex(minimumNoticeDays), Minimum),
  Days < Minimum.

risk_triggered(sharing_risk, Rule, _Need) :-
  rdf_link(ex('consumer-policy'), odrl(permission), Rule),
  rdf_link(Rule, odrl(action), ex(disclose)),
  \+ constraint_text(Rule, ex(explicitConsent), "true").

risk_triggered(portability_risk, Rule, _Need) :-
  rdf_link(ex('consumer-policy'), odrl(prohibition), Rule),
  rdf_link(Rule, odrl(action), ex(export)).

duty_action(Rule, Action) :-
  rdf_link(Rule, odrl(duty), Duty),
  rdf_link(Duty, odrl(action), Action).

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

risk_resource(deletion_risk, ex('deletion-risk')).
risk_resource(terms_risk, ex('terms-risk')).
risk_resource(sharing_risk, ex('sharing-risk')).
risk_resource(portability_risk, ex('portability-risk')).

mitigation_resource(require_notice_before_deletion, ex('require-notice-before-deletion')).
mitigation_resource(require_14_days_notice, ex('require-14-days-notice')).
mitigation_resource(require_explicit_consent, ex('require-explicit-consent')).
mitigation_resource(permit_data_export, ex('permit-data-export')).

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
