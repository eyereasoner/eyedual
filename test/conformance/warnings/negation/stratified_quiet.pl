% Stratified negation emits no portability warning.
query(answer(X0)).
candidate(a).
answer(ok) :- candidate(a), \+ blocked(a).
