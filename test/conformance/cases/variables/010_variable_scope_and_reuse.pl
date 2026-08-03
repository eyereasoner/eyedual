% Reference 5.1, 7.1: variable occurrences are scoped per clause and reused within a clause.
edge(a, b).
edge(b, c).
edge(c, d).
two_step(X, Z) :- edge(X, Y), edge(Y, Z).
answer(from_a, Z) :- two_step(a, Z).
answer(from_b, Z) :- two_step(b, Z).
%% goal: answer(X0, X1)

