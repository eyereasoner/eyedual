%% goal: answer(X0)

det(answer, 1).
semidet(aux, 1).
aux(ok).
answer(ok) :- aux(ok).
