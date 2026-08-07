% Reference 9.10: functor/3 reports atomic terms with arity zero and lists as ./2 cells.
%% goal: answer(X0, X1)

answer(atom, pair(Name, Arity)) :- functor(alpha, Name, Arity).
answer(quoted_atom, pair(Name, Arity)) :- functor('hello-world', Name, Arity).
answer(char_list, pair(Name, Arity)) :- functor("text", Name, Arity).
answer(number, pair(Name, Arity)) :- functor(123, Name, Arity).
answer(list_functor, pair(Name, Arity)) :- functor([a, b], Name, Arity).
