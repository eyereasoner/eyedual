% eq/2 unifies angle and quoted spellings of the same absolute IRI atom.
%% goal: answer(X0)

answer(ok) :- ('<urn:example:a>' = 'urn:example:a').
