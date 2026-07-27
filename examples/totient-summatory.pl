% Euler totients and coprimality by automatically tabled Euclidean gcd.
%
% phi(N) is modeled directly as the count of integers K in 1..N with gcd(N,K)=1.
% The summatory query reuses many gcd/totient subgoals, so memoization keeps the
% example responsive while preserving the relational presentation.
query(totient_answer(X0, X1)).


% Euclid's algorithm is expressed recursively over remainders.
gcd(A, 0, A) :- (A >= 0).
gcd(A, B, G) :-
  (B > 0),
  (R is A mod B),
  gcd(B, R, G).

coprime_upto(N, K) :-
  between(1, N, K),
  gcd(N, K, 1).

% Count the finite coprime generator instead of constructing an explicit list.
totient(N, Count) :-
  (N > 0),
  countall(coprime_upto(N, _k), Count).

summatory_totient(Limit, Sum) :-
  sumall(Phi, (between(1, Limit, N), totient(N, Phi)), Sum).

totient_answer(phi_36, Phi) :- totient(36, Phi).
totient_answer(phi_97, Phi) :- totient(97, Phi).
totient_answer(coprime_count_84, Count) :- totient(84, Count).
totient_answer(summatory_phi_30, Sum) :- summatory_totient(30, Sum).
