% Isolated ISO mode-table success case.
query(answer).
answer :- atom_concat(pro, Suffix, prolog), Suffix = log.
