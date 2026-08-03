% Quoted absolute IRI atoms use canonical angle-bracket read-back.
%% goal: answer(X0)

seed('urn:example:quoted').
answer(X) :- seed(X).
