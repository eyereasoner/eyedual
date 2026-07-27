% Adapted from Eyeling's fundamental-theorem-arithmetic.n3.
% Compute a prime factorization by repeated smallest-divisor decomposition,
% then check product reconstruction and primality of the distinct factors.

% Output declarations: query/1 selects the relations written to this example's golden output.
%
% The goal is not to be a production factorizer; it is a readable encoding of
% divisibility, primality, two factorization strategies, and agreement between
% normalized factor lists.
query(n(X0, X1)).
query(factorsSmallest(X0, X1)).
query(factorsLargest(X0, X1)).
query(product(X0, X1)).
query(expectedFactorsMatched(X0, X1)).
query(productReconstructsInput(X0, X1)).
query(distinctPrimeCount(X0, X1)).
query(smallestPrimeFactor(X0, X1)).
query(largestPrimeFactor(X0, X1)).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.
case(fta, 202692987).
expected_factors(fta, [3, 3, 7, 829, 3881]).

% A divides B in positive integers.
% Derivation rules: each rule below contributes one logical step toward the displayed results.
divides(A, B) :-
  (A > 0),
  (B > 0),
  (0 is B mod A).

smallest_divisor_from(N, D, D) :-
  divides(D, N).

smallest_divisor_from(N, D, N) :-
  (D2 is D * D),
  (D2 > N).

smallest_divisor_from(N, D, S) :-
  \+ divides(D, N),
  (D2 is D * D),
  (D2 =< N),
  (D1 is D + 1),
  smallest_divisor_from(N, D1, S).

trial_prime(2).
trial_prime(3).
% trial_prime/1 is the bounded primality test used by the factorization rules.
trial_prime(P) :-
  (P > 3),
  smallest_divisor_from(P, 2, P).

factor_smallest(N, []) :-
  (N < 2).

factor_smallest(N, [N]) :-
  (N >= 2),
  smallest_divisor_from(N, 2, N).

% factor_smallest/2 repeatedly removes the least divisor, producing ascending factors.
factor_smallest(N, Factors) :-
  (N >= 2),
  smallest_divisor_from(N, 2, D),
  (D \= N),
  (Q is N / D),
  factor_smallest(D, Left),
  factor_smallest(Q, Right),
  append(Left, Right, Factors).

factor_largest(N, Factors) :-
  factor_smallest(N, Smallest),
  reverse(Smallest, Factors).

product([], 1).
product([X|Rest], P) :-
  product(Rest, P0),
  (P is X * P0).

all_expected_primes(true) :-
  trial_prime(3),
  trial_prime(7),
  trial_prime(829),
  trial_prime(3881).

n(case, N) :-
  case(fta, N).

factorsSmallest(case, Factors) :-
  case(fta, N),
  factor_smallest(N, Factors).

factorsLargest(case, Factors) :-
  case(fta, N),
  factor_largest(N, Factors).

product(case, Product) :-
  case(fta, N),
  factor_smallest(N, Factors),
  product(Factors, Product).

expectedFactorsMatched(case, true) :-
  case(fta, N),
  expected_factors(fta, Factors),
  factor_smallest(N, Factors).

productReconstructsInput(case, true) :-
  case(fta, N),
  factor_smallest(N, Factors),
  product(Factors, N).

distinctPrimeCount(case, 4) :-
  all_expected_primes(true).

smallestPrimeFactor(case, 3) :-
  case(fta, N),
  factor_smallest(N, [3|_]).

largestPrimeFactor(case, 3881) :-
  case(fta, N),
  factor_largest(N, [3881|_]).
