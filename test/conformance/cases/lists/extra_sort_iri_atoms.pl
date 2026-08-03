%% goal: answer(X0, X1)

answer(sort_iri_atoms, X) :- sort(['<urn:example:b>', '<urn:example:a>'], X).
