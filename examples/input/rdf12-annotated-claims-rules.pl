% Source data: examples/input/rdf12-annotated-claims.ttl
% Regenerate with:
% node tools/rdf-to-pl.mjs --rules examples/input/rdf12-annotated-claims-rules.pl examples/input/rdf12-annotated-claims.ttl -o examples/rdf12-annotated-claims.pl
%
% Rank conflicting RDF 1.2 annotated claims by annotation confidence and
% source trust, then derive one auditable bridge-use decision.
%% goal: bridge_status_report(_)

bridge_status_report(
  report(
    decision(Action),
    evidence(trusted_source(Source), score(Score)),
    ranked_claims(Claims)
  )
) :-
  ranked_claims(Claims),
  bridge_decision(Claims, Action, Source, Score).

ranked_claims(Claims) :-
  findall(
    key(NegativeScore, Status)-claim(Status, Source, score(Score)),
    (
      annotated_status_claim(Status, Source, Score),
      NegativeScore is -Score
    ),
    Unsorted
  ),
  sort(Unsorted, Sorted),
  pair_values(Sorted, Claims).

annotated_status_claim(Status, Source, Score) :-
  status_resource(Status, StatusIri),
  source_resource(Source, SourceIri),
  rdf(
    iri('https://example.org/bridge'),
    iri('https://example.org/status'),
    iri(StatusIri),
    default_graph
  ),
  rdf(
    Reifier,
    iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'),
    triple(
      iri('https://example.org/bridge'),
      iri('https://example.org/status'),
      iri(StatusIri)
    ),
    default_graph
  ),
  rdf(
    Reifier,
    iri('https://example.org/assertedBy'),
    iri(SourceIri),
    default_graph
  ),
  rdf_number(Reifier, "https://example.org/confidence", Confidence),
  rdf_number(iri(SourceIri), "https://example.org/trustScore", Trust),
  Score is Confidence * Trust.

bridge_decision(
  [claim(Status, Source, score(Score))|_],
  Action,
  Source,
  Score
) :-
  Score >= 8000,
  status_action(Status, Action).
bridge_decision(
  [claim(_Status, _Source, score(Score))|_],
  verify_manually,
  no_trusted_source,
  Score
) :-
  Score < 8000.
bridge_decision([], verify_manually, no_trusted_source, 0).

rdf_number(Subject, PredicateIri, Number) :-
  rdf(
    Subject,
    iri(PredicateIri),
    literal(Text, datatype(_Datatype)),
    default_graph
  ),
  number_string(Number, Text).

pair_values([], []).
pair_values([_Key-Value|Pairs], [Value|Values]) :-
  pair_values(Pairs, Values).

status_action(closed, avoid_bridge).
status_action(open, cross_bridge).

status_resource(closed, "https://example.org/closed").
status_resource(open, "https://example.org/open").
source_resource(transport_authority, "https://example.org/transportAuthority").
source_resource(anonymous_post, "https://example.org/anonymousPost").
