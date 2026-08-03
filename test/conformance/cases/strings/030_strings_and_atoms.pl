% Reference 9.6: atom and string built-ins.
answer(str_concat, X) :- str_concat("web", "entail", X).
answer(contains, true) :- contains("webentail", "web").
%% goal: answer(X0, X1)

