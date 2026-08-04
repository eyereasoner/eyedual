% Reference 9.6: atom and string built-ins.
answer(string_concat, X) :- string_concat("eye", "dual", X).
answer(contains, true) :- contains("eyedual", "eye").
%% goal: answer(X0, X1)

