%% goal: answer(X0)

context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).
answer(ok) :- context_member((likes(alice, tea), likes(bob, coffee)), likes(alice, tea)).
