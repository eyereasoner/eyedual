% Prime ranges and Euler totient over finite integer domains.
%
% The source example combines prime search with Euler's totient function.  This
% EyeDual version keeps the computation finite and declarative: composite
% numbers are described by proper divisors, primes are candidates that are not
% composite, and `totient/2` counts numbers coprime with the input.

%% goal: prime_result(X0, X1)


candidate(N) :-
  between(2, 30, N).

composite(N) :-
  candidate(N),
  between(2, N, D),
  (D < N),
  (0 is N mod D).

prime(N) :-
  candidate(N),
  \+ composite(N).

% Euclid's algorithm, used for the totient calculation.
gcd(N, 0, N).
gcd(N, M, G) :-
  (M > 0),
  (R is N mod M),
  gcd(M, R, G).

coprime(N, K) :-
  between(1, N, K),
  gcd(N, K, 1).

totient(N, Phi) :-
  countall(coprime(N, _k), Phi).

prime_result(range_2_30, Primes) :-
  findall(P, prime(P), Primes).

prime_result(count_2_30, Count) :-
  countall(prime(P), Count).

prime_result(totient_271, Phi) :-
  totient(271, Phi).
