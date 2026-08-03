%% goal: answer(X0)

answer(compound_name_arguments_bad_args_fails) :- (_ =.. [pair | not_a_list]).
