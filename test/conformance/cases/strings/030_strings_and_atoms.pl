% Reference 9.6: atom and string built-ins.
answer(string_concat, X) :- string_concat('eye', 'prolog', X).
answer(contains, true) :- contains('eyeprolog', 'eye').
%% goal: answer(X0, X1)

