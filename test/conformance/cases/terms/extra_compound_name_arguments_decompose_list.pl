%% goal: answer(X0, X1, X2)

answer(compound_name_arguments_decompose_list, Name, Args) :- ([a | b] =.. [Name | Args]).
