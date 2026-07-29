% Isolated ISO mode-table success case.
query(answer).
answer :- catch(throw(ball), ball, true).
