% `memoize/2` is no longer a declaration, but it remains an ordinary fact.
%% goal: answer(X0, X1)

memoize(path, 2).
answer(Name, Arity) :- memoize(Name, Arity).
