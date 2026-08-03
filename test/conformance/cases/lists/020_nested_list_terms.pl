% Reference 5.3, 5.4: lists may contain structured terms that unify positionally.
node([pair(a, b), pair(c, d)]).
answer(first_key, X) :- node([pair(X, _), pair(c, d)]).
answer(second_key, X) :- node([pair(a, b), pair(X, d)]).
%% goal: answer(X0, X1)

