% Reference 9.3, 9.6: lexical comparison and simple text matching.
answer(matches, true) :- matches("eyedual", "eye").
answer(not_matches, true) :- \+ matches("eyedual", "cat").
answer(lex_lt, true) :- (alpha @< beta).
answer(lex_gt, true) :- (beta @> alpha).
answer(numeric_le, true) :- (2 =< 2).
%% goal: answer(X0, X1)

