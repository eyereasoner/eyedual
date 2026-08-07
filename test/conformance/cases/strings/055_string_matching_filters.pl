% Reference 9.6: matches/2 and not_matches/2 can filter candidate strings.
text(a, 'alpha').
text(b, 'beta').
answer(has_ph, K) :- text(K, T), matches(T, 'ph').
answer(no_ph, K) :- text(K, T), \+ matches(T, 'ph').
%% goal: answer(X0, X1)

