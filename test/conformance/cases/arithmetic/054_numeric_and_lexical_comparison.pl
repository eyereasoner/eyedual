% Reference 9.3: comparisons handle numeric and lexical scalar ordering.
answer(numeric_gt, true) :- (10 > 2).
answer(numeric_le, true) :- (2 =< 2.0).
answer(lexical_ge, true) :- (beta @>= alpha).
%% goal: answer(X0, X1)

