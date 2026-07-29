% Isolated ISO mode-table success case.
query(answer).
answer :- atom_chars(Atom, [c, a, t]), Atom = cat.
