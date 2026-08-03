% Reference 5.5, 7: formula data can be passed through parenthesized conjunctions.
record((left(a), right(b))).
accept((left(a), right(b))).
answer(ok, F) :- (record(F), accept(F)).
%% goal: answer(X0, X1)

