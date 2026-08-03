%% goal: answer(X0, X1, X2)

answer(number, Name, Arity) :- functor(42, Name, Arity).
answer(string, Name, Arity) :- functor("hi", Name, Arity).
