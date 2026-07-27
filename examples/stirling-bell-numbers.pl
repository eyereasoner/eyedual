% Stirling numbers of the second kind and Bell numbers.
%
% The Stirling count S(N,K) is computed with the inclusion-exclusion formula
%   S(N,K) = (1/K!) * sum(I=0..K, (-1)^(K-I) * C(K,I) * I^N)
% instead of the overlapping two-branch recurrence.  Bell numbers use
%   B(0) = 1, B(N) = sum(K=0..N-1, C(N-1,K) * B(K)).
% The table declarations memoize the smaller helper relations used by both formulas.
query(stirling_bell_answer(X0, X1)).


factorial(0, 1).
factorial(N, Value) :-
  (N > 0),
  (N1 is N - 1),
  factorial(N1, Previous),
  (Value is N * Previous).

binomial(0, 0, 1).
binomial(N, 0, 1) :- (N > 0).
binomial(N, N, 1) :- (N > 0).
binomial(N, K, Value) :-
  (N > 0),
  (K > 0),
  (K < N),
  (N1 is N - 1),
  (K1 is K - 1),
  binomial(N1, K1, Left),
  binomial(N1, K, Right),
  (Value is Left + Right).

signed_term(N, K, I, Term) :-
  binomial(K, I, C),
  (P is I ** N),
  (Unsigned is C * P),
  (D is K - I),
  (0 is D mod 2),
  (Term = Unsigned).
signed_term(N, K, I, Term) :-
  binomial(K, I, C),
  (P is I ** N),
  (Unsigned is C * P),
  (D is K - I),
  (1 is D mod 2),
  (Term is -(Unsigned)).

stirling2(0, 0, 1).
stirling2(N, 0, 0) :- (N > 0).
stirling2(0, K, 0) :- (K > 0).
stirling2(N, K, Count) :-
  (N > 0),
  (K > 0),
  sumall(Term, (between(0, K, I), signed_term(N, K, I, Term)), Sum),
  factorial(K, Factorial),
  (Count is Sum / Factorial).

bell(0, 1).
bell(N, Count) :-
  (N > 0),
  (N1 is N - 1),
  sumall(Term, (between(0, N1, K), binomial(N1, K, Choose), bell(K, Bell), (Term is Choose * Bell)), Count).

stirling_bell_answer(stirling_10_4, Count) :- stirling2(10, 4, Count).
stirling_bell_answer(stirling_12_5, Count) :- stirling2(12, 5, Count).
stirling_bell_answer(bell_10, Count) :- bell(10, Count).
stirling_bell_answer(bell_12, Count) :- bell(12, Count).
