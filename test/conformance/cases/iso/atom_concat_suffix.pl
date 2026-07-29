% Isolated ISO mode-table success case.
query(answer).
answer :- atom_concat(Prefix, log, prolog), Prefix = pro.
