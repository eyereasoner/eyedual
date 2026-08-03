% Lists can contain IRI atoms directly.
%% goal: answer(X0)

seed(['<urn:example:a>', '<urn:example:b>']).
answer(X) :- seed(X).
