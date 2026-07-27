% Angle-bracket and quoted spellings denote the same absolute IRI atom.
query(answer(X0)).
answer(ok) :- ('<urn:example:a>' = 'urn:example:a').
