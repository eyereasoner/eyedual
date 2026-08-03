%% goal: answer(X0, X1, X2)

context_statement(alpha).
context_statement(beta(2)).
context_parts(Name, Args) :- context_statement(Statement), (Statement =.. [Name | Args]), atom(Name).
answer(context_parts, Name, Args) :- context_parts(Name, Args).
