% Stratified negation is portable and produces ordinary answers.
query(open(X0)).
place(a).
place(b).
closed(b).
open(X) :- place(X), \+ closed(X).
