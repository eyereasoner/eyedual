%% goal: answer(X0, X1)

answer(join_iri_and_atom, X) :- join(['<urn:example:a>', path, 7], '/', X).
