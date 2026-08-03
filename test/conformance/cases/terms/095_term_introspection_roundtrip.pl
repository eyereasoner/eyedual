% Reference 9.10: term inspection can decompose and recompose compound terms.
%% goal: answer(X0, X1)

answer(functor_compound, pair(Name, Arity)) :- functor(edge(a, b), Name, Arity).
answer(arg_first, X) :- arg(1, edge(a, b), X).
answer(arg_second, X) :- arg(2, edge(a, b), X).
answer(decompose, pair(Name, Args)) :- (edge(a, b) =.. [Name | Args]).
answer(recompose, X) :- (X =.. [edge | [a, b]]).
answer(roundtrip, X) :- (edge(a, b) =.. [Name | Args]), (X =.. [Name | Args]).
