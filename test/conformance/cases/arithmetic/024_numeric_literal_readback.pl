% Reference 3.3, 11: signed, decimal, and exponent numeric literals retain lexical form.
raw(negative_decimal, -3.5).
raw(positive_exp, 6.02e23).
raw(negative_exp, -1.0e-3).
answer(K, V) :- raw(K, V).
%% goal: answer(X0, X1)

