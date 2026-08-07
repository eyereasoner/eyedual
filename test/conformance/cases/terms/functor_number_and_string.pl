%% goal: answer(X0, X1, X2)

answer(number, Name, Arity) :- functor(42, Name, Arity).
answer(char_list, Name, Arity) :- functor("hi", Name, Arity).
