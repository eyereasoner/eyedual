%% goal: answer(X0, X1)

context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).
context_parts(Context, Name, Args) :- context_member(Context, Statement), (Statement =.. [Name | Args]), atom(Name).
answer(First, Last) :- matches('Ada Lovelace', '^(?<first>[A-Za-z]+) (?<last>[A-Za-z]+)$', Ctx), context_parts(Ctx, first, First), context_parts(Ctx, last, Last).
