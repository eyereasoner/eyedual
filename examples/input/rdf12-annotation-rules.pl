% Recover an asserted triple together with its RDF 1.2 annotations.
%% goal: annotated_claim(_, _, _, _, _, _)

annotated_claim(S, P, O, Reifier, Source, Date) :-
  rdf(S, P, O, default_graph),
  rdf(
    Reifier,
    iri('http://www.w3.org/1999/02/22-rdf-syntax-ns#reifies'),
    triple(S, P, O),
    default_graph
  ),
  rdf(
    Reifier,
    iri('https://example.org/statedBy'),
    Source,
    default_graph
  ),
  rdf(
    Reifier,
    iri('https://example.org/recorded'),
    Date,
    default_graph
  ).
