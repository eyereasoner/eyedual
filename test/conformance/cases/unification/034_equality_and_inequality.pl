% Reference 9.1: eq/2 unifies terms and neq/2 succeeds on non-unifiable terms.
answer(eq_variable, X) :- (X = pair(a, [b, c])).
answer(eq_nested, true) :- (pair(X, X) = pair(same, same)).
answer(neq_atoms, true) :- (alice \= bob).
answer(neq_structures, true) :- (pair(a) \= pair(a, b)).
%% goal: answer(X0, X1)

