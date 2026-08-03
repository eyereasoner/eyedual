% Reference 9.5, 9.10: generators, negation as failure, and once/1.
candidate(a).
candidate(b).
closed(b).
answer(open, X) :- candidate(X), \+ closed(X).
answer(first_between, X) :- once(between(2, 4, X)).
%% goal: answer(X0, X1)

