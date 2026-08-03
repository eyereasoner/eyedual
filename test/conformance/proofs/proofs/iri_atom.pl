% Reference 12: proof output preserves angle-bracket IRI atom read-back.
%% goal: label(X0, X1)

name('<urn:example:a>', "Alice").
label(Iri, Name) :- name(Iri, Name).
