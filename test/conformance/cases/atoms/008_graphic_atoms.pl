% Reference 3.5, 5.2, 11: graphic atom constants are scalar terms.
%% goal: value(X0, X1)

raw_value(hash, #).
raw_value(arrow, =>).
raw_value(comparison, =<).
value(K, V) :- raw_value(K, V).
