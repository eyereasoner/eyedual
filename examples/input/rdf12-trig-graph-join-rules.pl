% Join graph metadata in the default graph with data from the named graph.
rdf(S, iri('https://example.org/reportedBy'), Station, default_graph) :-
  rdf(
    iri('https://example.org/sensorGraph'),
    iri('https://example.org/reportedBy'),
    Station,
    default_graph
  ),
  rdf(
    S,
    iri('https://example.org/temperature'),
    _,
    iri('https://example.org/sensorGraph')
  ).
%% goal: rdf(X0, X1, X2, X3)
