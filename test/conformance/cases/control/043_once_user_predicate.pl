% Reference 9.10: once/1 keeps at most the first solution from a user predicate.
choice(a).
choice(b).
answer(first, X) :- once(choice(X)).
%% goal: answer(X0, X1)

