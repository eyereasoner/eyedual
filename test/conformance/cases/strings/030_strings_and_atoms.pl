% Reference 9.6: atom and string built-ins.
answer(string_concat, X) :- string_concat("eye", "lang", X).
answer(contains, true) :- contains("eyelang", "eye").
%% goal: answer(X0, X1)

