% Building a term with an empty argument list yields an atom, not nil().
%% goal: answer(X0)

answer(Term) :- (Term =.. [nil | []]).
