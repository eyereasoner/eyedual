% Stratified negation emits no portability warning.
%% goal: answer(X0)

candidate(a).
answer(ok) :- candidate(a), \+ blocked(a).
