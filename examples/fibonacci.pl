% Fibonacci numbers by fast doubling.
%
% The public fibonacci/2 relation is bounded by fib_case/1 facts, while fib_pair/3
% computes F(N) and F(N+1) together.  This exposes a logarithmic recursive
% algorithm in a small relational program instead of enumerating all predecessors.
%
% Memoization is important for the large cases: several requested Fibonacci
% numbers reuse the same half-size fib_pair/3 subproblems.
%% goal: fibonacci(X0, X1)


% fib_case/1 bounds the public queries, while fib_pair/3 implements the
% fast-doubling recurrence F(2n), F(2n+1) over arbitrary-size integers.

% BigInt Fibonacci via fast doubling, implemented in Prolog using generic
% decimal add/sub/mul built-ins.  The result predicate follows Eyeling's
% fibonacci.n3 output shape: N fibonacci Value.
fib_case(0).
fib_case(1).
fib_case(10).
fib_case(100).
fib_case(1000).
fib_case(10000).

% The even and odd fib_pair/3 clauses share the same half-size recursive call;
% memoization makes repeated large cases reuse those subproblems.
fib(N, Value) :- fib_pair(N, Value, _next).

fib_pair(0, 0, 1).
fib_pair(N, F, G) :-
  (N > 0),
  (Half is N // 2),
  fib_pair(Half, A, B),
  (Twob is B * 2),
  (Twobminusa is Twob - A),
  (C is A * Twobminusa),
  (Aa is A * A),
  (Bb is B * B),
  (D is Aa + Bb),
  (0 is N mod 2),
  (F = C),
  (G = D).
fib_pair(N, F, G) :-
  (N > 0),
  (Half is N // 2),
  fib_pair(Half, A, B),
  (Twob is B * 2),
  (Twobminusa is Twob - A),
  (C is A * Twobminusa),
  (Aa is A * A),
  (Bb is B * B),
  (D is Aa + Bb),
  (1 is N mod 2),
  (Next is C + D),
  (F = D),
  (G = Next).

fibonacci(N, Value) :-
  fib_case(N),
  fib(N, Value).
