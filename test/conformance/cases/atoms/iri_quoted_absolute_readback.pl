% Quoted absolute IRI atoms read back in angle-bracket form.
%% goal: answer(X0)

item('https://example.org/alice').
item('urn:example:bob').
answer(Iri) :- item(Iri).
