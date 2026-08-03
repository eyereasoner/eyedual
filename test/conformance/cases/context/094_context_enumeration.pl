% Reference 9.9: recursion and =../2 enumerate comma-context terms left to right.
%% goal: answer(X0, X1)

context((kind(alert), severity(high), owner(alice))).
context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).
context_parts(Context, Name, Args) :- context_member(Context, Statement), (Statement =.. [Name | Args]), atom(Name).
answer(term, X) :- context(C), context_member(C, X).
answer(parts, pair(Name, Args)) :- context(C), context_parts(C, Name, Args).
answer(filter, X) :- context(C), context_member(C, owner(X)).
answer(missing_rejected, ok) :- context(C), \+ context_member(C, status(open)).
