%% goal: answer(X0, X1, X2)

context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).
answer(Name, Left, Right) :- context_member((edge(a, b), label(a, "A")), Statement), (Statement =.. [Name, Left, Right]).
