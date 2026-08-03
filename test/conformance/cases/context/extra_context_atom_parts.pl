%% goal: answer(X0, X1, X2)

context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).
context_parts(Context, Name, Args) :- context_member(Context, Statement), (Statement =.. [Name | Args]), atom(Name).
answer(context_atom_parts, Name, Args) :- context_parts((ready, box(a)), Name, Args).
