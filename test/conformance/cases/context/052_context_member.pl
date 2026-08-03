% Reference 9.9: ordinary recursion over comma context data.
%% goal: answer(X, Term)

context((name(alice, "Alice"), knows(alice, bob))).
context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).
answer(member, Term) :- context(C), context_member(C, Term).
