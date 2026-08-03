%% goal: answer(X0, X1, X2)

answer(compound_name_arguments, Name, Args) :- (box(a, b) =.. [Name | Args]).
