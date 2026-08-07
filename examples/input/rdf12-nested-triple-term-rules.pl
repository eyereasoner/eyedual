% Match nested RDF 1.2 triple terms and derive the innermost relationship.
rdf(S, iri('https://example.org/knows'), O, G) :-
  rdf(
    _,
    iri('https://example.org/reviews'),
    triple(
      _,
      iri('https://example.org/claims'),
      triple(S, iri('https://example.org/knows'), O)
    ),
    G
  ).
%% goal: rdf(X0, X1, X2, X3)
