% Isolated ISO mode-table success case.
query(answer).
answer :- char_code(Char, 955), Char = 'λ'.
