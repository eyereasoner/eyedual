%% goal: answer(X0, X1)

answer(compound_name_arguments_construct_iri, X) :- (X =.. ['<urn:example:pair>' | [a, b]]).
