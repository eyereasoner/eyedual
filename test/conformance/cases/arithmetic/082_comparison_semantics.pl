% Reference 9.3: comparison handles numbers, durations, character lists, and lexical scalars.
%% goal: answer(X0, X1)

answer(integer_order, ok) :- (9 < 10).
answer(decimal_equal_le, ok) :- (2.0 =< 2).
answer(numeric_not_lexical, ok) :- (10 < 100).
answer(duration_years, ok) :- ('P1Y' @< 'P2Y').
answer(duration_months, ok) :- ('P1Y1M' @> 'P1Y').
answer(atom_lexical, ok) :- (alpha @< beta).
answer(char_list_order, ok) :- ("z" @> "a").
answer(compound_lexical_text, ok) :- (pair(a, 1) @< pair(b, 1)).
