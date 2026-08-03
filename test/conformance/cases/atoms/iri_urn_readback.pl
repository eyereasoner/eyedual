% URN IRI atoms read back in angle-bracket form.
%% goal: answer(X0)

seed('<urn:example:alpha>').
answer(X) :- seed(X).
