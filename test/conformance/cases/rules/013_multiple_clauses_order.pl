% Reference 6, 7: multiple clauses for one predicate are explored as alternatives.
color(red).
color(blue).
paint(X) :- color(X).
answer(color, X) :- paint(X).
%% goal: answer(X0, X1)

