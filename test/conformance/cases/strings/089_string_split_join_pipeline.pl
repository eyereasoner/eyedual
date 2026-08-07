% Reference 9.6: split/join/trim compose for simple data-cleaning workflows.
%% goal: answer(X0, X1)

raw('  alpha,beta,gamma  ').
answer(parts, X) :- raw(R), trim(R, T), split(T, ',', X).
answer(pipe, X) :- raw(R), trim(R, T), split(T, ',', Parts), join(Parts, '|', X).
answer(first_upper, X) :- raw(R), trim(R, T), split(T, ',', [H|_tail]), uppercase(H, X).
answer(last_lower, X) :- raw(R), trim(R, T), split(T, ',', Parts), last(Parts, L), lowercase(L, X).
