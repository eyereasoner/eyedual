%% goal: answer(X0, X1)

answer(named_regex_optional_missing, X) :- matches('abc', '(?<first>a)(?<missing>z)?', X).
