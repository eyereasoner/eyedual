% Source data: examples/input/dpv-odrl-purpose-mapping.ttl
% Regenerate with:
% node tools/rdf-to-eyedual.mjs --rules examples/input/dpv-odrl-purpose-mapping-rules.pl examples/input/dpv-odrl-purpose-mapping.ttl -o examples/dpv-odrl-purpose-mapping.pl
%
% The DPV process and ODRL policy are RDF data. The rules verify the six
% correspondences and return one deterministic mapping report.
%% goal: dpv_odrl_purpose_mapping(_)

dpv_odrl_purpose_mapping(Mappings) :-
  findall(
    mapping(SourceRole, Value, TargetRole),
    mapped_role(SourceRole, Value, TargetRole),
    Mappings
  ).

mapped_role(data_controller, Controller, assigner) :-
  rdf_link(ex(alpha_care_process), dpv(hasDataController), ex(Controller)),
  rdf_link(ex(alpha_permission), odrl(assigner), ex(Controller)).

mapped_role(recipient, Recipient, assignee) :-
  rdf_link(ex(alpha_care_process), dpv(hasRecipient), ex(Recipient)),
  rdf_link(ex(alpha_permission), odrl(assignee), ex(Recipient)).

mapped_role(personal_data, Data, target) :-
  rdf_link(ex(alpha_care_process), dpv(hasPersonalData), ex(Data)),
  rdf_link(ex(alpha_permission), odrl(target), ex(Data)).

mapped_role(processing, dpv_use, action) :-
  rdf_link(ex(alpha_care_process), dpv(hasProcessing), dpv('Use')),
  rdf_link(ex(alpha_permission), odrl(action), odrl(use)).

mapped_role(purpose, dpv_healthcare, constraint(alpha_purpose_constraint)) :-
  rdf_link(ex(alpha_care_process), dpv(hasPurpose), dpv('Healthcare')),
  odrl_constraint(alpha_purpose_constraint, odrl(purpose), dpv('Healthcare')).

mapped_role(legal_basis, dpv_consent, constraint(alpha_basis_constraint)) :-
  rdf_link(ex(alpha_care_process), dpv(hasLegalBasis), dpv('Consent')),
  odrl_constraint(alpha_basis_constraint, ex(legalBasis), dpv('Consent')).

odrl_constraint(Name, LeftOperand, RightOperand) :-
  rdf_link(ex(alpha_permission), odrl(constraint), ex(Name)),
  rdf_link(ex(Name), odrl('leftOperand'), LeftOperand),
  rdf_link(ex(Name), odrl(operator), odrl('isA')),
  rdf_link(ex(Name), odrl('rightOperand'), RightOperand).

rdf_link(Subject, Predicate, Object) :-
  iri_term(Subject, SubjectIri),
  iri_term(Predicate, PredicateIri),
  rdf(iri(SubjectIri), iri(PredicateIri), iri(ObjectIri), default_graph),
  iri_term(Object, ObjectIri).

iri_term(ex(Name), Iri) :- namespace_iri("https://example.org/", Name, Iri).
iri_term(dpv(Name), Iri) :- namespace_iri("https://w3id.org/dpv#", Name, Iri).
iri_term(odrl(Name), Iri) :- namespace_iri("http://www.w3.org/ns/odrl/2/", Name, Iri).

namespace_iri(Prefix, Name, Iri) :-
  atom(Name),
  !,
  atom_string(Name, Local),
  string_concat(Prefix, Local, Iri).
namespace_iri(Prefix, Name, Iri) :-
  string_concat(Prefix, Local, Iri),
  atom_string(Name, Local).
