%% goal: answer(X0, X1)

answer(term_string_iri_list, X) :- term_string(['<urn:example:a>', box('B')], X).
