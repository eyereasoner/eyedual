%% goal: answer(X0, X1)

answer(reverse_nested_terms, X) :- reverse([box(a), [b, c], '<urn:example:d>'], X).
