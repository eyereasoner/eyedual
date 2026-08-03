% atom_string/2 converts an IRI atom to its lexical string.
%% goal: answer(X0)

answer(Text) :- atom_string('<urn:example:a>', Text).
