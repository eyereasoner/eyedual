% Reference 9.1: term introspection/construction, term strings, and forall/2.
%% goal: answer(X0, X1)

item(1).
item(2).
item(3).
answer(functor, pair(Name, Arity)) :- functor(edge(a, b), Name, Arity).
answer(arg, X) :- arg(2, edge(a, b), X).
answer(decompose, pair(Name, Args)) :- (edge(a, b) =.. [Name | Args]).
answer(compose, X) :- (X =.. [edge | [a, b]]).
answer(term_string, X) :- term_string(edge(a, [b, c]), X).
answer(forall, ok) :- \+ item_counterexample.
item_counterexample :- item(X), \+ (X < 4).
