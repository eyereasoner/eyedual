% Reference 9.1: term-inspection built-ins expose scalars, nested arguments, and atom construction from an empty argument list.
%% goal: answer(X0, X1)

answer(functor_atom, pair(Name, Arity)) :- functor(alpha, Name, Arity).
answer(functor_number, pair(Name, Arity)) :- functor(42, Name, Arity).
answer(functor_char_list, pair(Name, Arity)) :- functor("hi", Name, Arity).
answer(arg_nested, X) :- arg(1, path(edge(a, b), c), X).
answer(compose_nested, X) :- (X =.. [outer | [inner(a), [b, c]]]).
answer(compose_atom_empty_args, X) :- (X =.. [z | []]).
answer(decompose_atom_empty_args, pair(Name, Args)) :- (z =.. [Name | Args]).
answer(arg_zero_rejected, ok) :- \+ arg(0, edge(a, b), X).
answer(arg_too_large_rejected, ok) :- \+ arg(3, edge(a, b), X).
