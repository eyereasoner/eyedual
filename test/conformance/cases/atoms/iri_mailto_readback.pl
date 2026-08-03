% Non-http absolute IRI atoms are ordinary atoms.
%% goal: answer(X0)

seed('<mailto:alice@example.org>').
answer(X) :- seed(X).
