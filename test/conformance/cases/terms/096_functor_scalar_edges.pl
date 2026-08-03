% Reference 9.10: functor/3 reports scalar terms with arity zero.
%% goal: answer(X0, X1)

answer(atom, pair(Name, Arity)) :- functor(alpha, Name, Arity).
answer(quoted_atom, pair(Name, Arity)) :- functor('hello-world', Name, Arity).
answer(string, pair(Name, Arity)) :- functor("text", Name, Arity).
answer(number, pair(Name, Arity)) :- functor(123, Name, Arity).
answer(list_functor, pair(Name, Arity)) :- functor([a, b], Name, Arity).
