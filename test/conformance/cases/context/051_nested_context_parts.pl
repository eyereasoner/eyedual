% Reference 9.9: ordinary clauses enumerate nested comma contexts.
context(((ready, name(a, "A")), route(a, b, 7))).
context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).
context_parts(Context, Name, Args) :- context_member(Context, Statement), (Statement =.. [Name | Args]), atom(Name).
answer(parts, exposed(Name, Args)) :- context(C), context_parts(C, Name, Args).
%% goal: answer(X0, X1)

