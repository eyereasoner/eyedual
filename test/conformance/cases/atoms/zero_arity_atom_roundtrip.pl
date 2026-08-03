% Arity-zero data is represented as atoms, never zero-arity compounds.
%% goal: answer(X0, X1)

answer(name, Name) :- (nil =.. [Name | Args]).
answer(args, Args) :- (nil =.. [Name | Args]).
answer(term, Term) :- (Term =.. [nil | []]).
