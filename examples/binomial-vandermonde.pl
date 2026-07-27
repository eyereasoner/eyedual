% Binomial coefficients and Vandermonde's identity.
%
% choose(N,K,C) is computed by a multiplicative recurrence, then vandermonde/5 checks
% the finite convolution sum: sum_i C(R,i) C(S,N-i) = C(R+S,N).  Memoization keeps
% the binomial-row prefixes shared across both sides of the identity.
% choose_step/5 uses the multiplicative recurrence
%   C(N, I+1) = C(N, I) * (N-I) / (I+1)
% and is cached automatically because row sums and identities reuse prefixes.
query(binomial_answer(X0, X1)).


choose(N, K, C) :-
  (K >= 0),
  (K =< N),
  choose_step(N, K, 0, 1, C).

choose_step(_n, K, K, Acc, Acc).
choose_step(N, K, I, Acc, C) :-
  (I < K),
  (I1 is I + 1),
  (Factor is N - I),
  (Numerator is Acc * Factor),
  (Nextacc is Numerator / I1),
  choose_step(N, K, I1, Nextacc, C).

symmetric(N, K) :-
  choose(N, K, C),
  (Otherk is N - K),
  choose(N, Otherk, C).

vandermonde_sum(N, M, R, Sum) :-
  sumall(Product,
    (between(0, R, K),
     (Rk is R - K),
     choose(N, K, A),
     choose(M, Rk, B),
     (Product is A * B)),
    Sum).

vandermonde(N, M, R, Sum) :-
  (Totaln is N + M),
  choose(Totaln, R, Sum),
  vandermonde_sum(N, M, R, Sum).

binomial_answer(choose_24_12, C) :- choose(24, 12, C).
binomial_answer(symmetry_24_7, true) :- symmetric(24, 7).
binomial_answer(vandermonde_12_10_8, Sum) :- vandermonde(12, 10, 8, Sum).
binomial_answer(row_12_sum, Sum) :- sumall(C, (between(0, 12, K), choose(12, K, C)), Sum).
