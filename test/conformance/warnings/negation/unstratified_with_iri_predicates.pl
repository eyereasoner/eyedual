%% goal: answer(X0)

p('<urn:example:a>') :- \+ q('<urn:example:a>').
q('<urn:example:a>') :- \+ p('<urn:example:a>').
answer(ok).
