query(answer(X0)).
item(a).
answer(X) :- item(X), \+ missing(X).
