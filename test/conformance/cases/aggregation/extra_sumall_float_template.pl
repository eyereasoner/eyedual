%% goal: answer(X0, X1)

val(1.5).
val(2.25).
answer(sumall_float_template, Sum) :- sumall(X, val(X), Sum).
