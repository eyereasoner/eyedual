%% goal: answer(X0, X1, X2)

rank('<urn:example:a>', low).
rank('<urn:example:z>', high).
answer(aggregate_max_iri_key, Key, Value) :- aggregate_max(K, V, rank(K, V), Key, Value).
