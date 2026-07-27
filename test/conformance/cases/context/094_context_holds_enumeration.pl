% Reference 9.9: holds/2 and holds/3 enumerate comma-context terms left to right.
query(answer(X0, X1)).
context((kind(alert), severity(high), owner(alice))).
answer(term, X) :- context(C), holds(C, X).
answer(parts, pair(Name, Args)) :- context(C), holds(C, Name, Args).
answer(filter, X) :- context(C), holds(C, owner(X)).
answer(missing_rejected, ok) :- context(C), \+ holds(C, status(open)).
