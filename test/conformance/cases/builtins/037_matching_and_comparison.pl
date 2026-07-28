% Reference 9.3, 9.6: lexical comparison and simple text matching.
answer(matches, true) :- matches("eyepl", "ey").
answer(not_matches, true) :- \+ matches("eyepl", "cat").
answer(lex_lt, true) :- (alpha @< beta).
answer(lex_gt, true) :- (beta @> alpha).
answer(numeric_le, true) :- (2 =< 2).
query(answer(X0, X1)).
