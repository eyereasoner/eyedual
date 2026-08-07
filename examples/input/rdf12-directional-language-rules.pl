% Preserve RDF 1.2 base-direction metadata while deriving display labels.
%% goal: rdf(X0, X1, X2, X3)

rdf(S, iri('https://example.org/displayLabel'), Label, G) :-
  rdf(S, iri('https://example.org/label'), Label, G).
