% Prime enumeration inspired by Eyelet input/sieve.pl.
% The 1000-limit answer matches Eyelet output-swipl/sieve.pl.
%
% A plain-Prolog 6k-1/6k+1 candidate wheel preserves the same generated prime
% list without requiring a host accelerator.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: primes(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
want_primes(1000).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
prime_under(Limit, 2) :-
  (Limit >= 2).

prime_under(Limit, 3) :-
  (Limit >= 3).

% Starting at 5, alternating steps of 2 and 4 generates exactly the 6k-1 and
% 6k+1 candidates, excluding every larger multiple of 2 or 3.
prime_candidate(Current, High, _, Current) :-
  (Current =< High).

prime_candidate(Current, High, Step, Value) :-
  (Current < High),
  (Next is Current + Step),
  (NextStep is 6 - Step),
  !,
  prime_candidate(Next, High, NextStep, Value).

prime_from(N, Divisor, _) :-
  (Divisor * Divisor > N).

prime_from(N, Divisor, Step) :-
  (Divisor * Divisor =< N),
  (N mod Divisor =\= 0),
  (Next is Divisor + Step),
  (NextStep is 6 - Step),
  !,
  prime_from(N, Next, NextStep).

prime_under(Limit, P) :-
  prime_candidate(5, Limit, 2, P),
  prime_from(P, 5, 2).

primes(Limit, Ps) :-
  want_primes(Limit),
  findall(P, prime_under(Limit, P), Ps).
