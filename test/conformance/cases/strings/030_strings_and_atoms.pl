% Reference 9.6: atom and string built-ins.
answer(str_concat, X) :- str_concat("eye", "dual", X).
answer(contains, true) :- contains("eyedual", "eye").
%% goal: answer(X0, X1)

