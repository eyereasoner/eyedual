% Reference 9.6: atom and string built-ins.
answer(str_concat, X) :- str_concat("eye", "pl", X).
answer(contains, true) :- contains("eyepl", "ey").
%% goal: answer(X0, X1)

