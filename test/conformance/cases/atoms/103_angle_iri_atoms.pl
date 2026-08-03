% Reference 3.5: absolute IRIs may be written as angle-bracket atom constants.
%% goal: iri_subject(X0)

%% goal: iri_object(X0)

triple('<https://example.org/alice>', '<https://schema.org/name>', "Alice").
triple('<urn:example:bob>', '<https://schema.org/knows>', '<https://example.org/alice>').
iri_subject(Iri) :- triple(Iri, _, _).
iri_object(Iri) :- triple(_, '<https://schema.org/knows>', Iri).
