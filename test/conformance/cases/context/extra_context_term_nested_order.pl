%% goal: answer(X0, X1)

context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).
answer(context_term_nested_order, X) :- context_member((a, (b, c)), X).
