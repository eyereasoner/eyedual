% Collatz conjecture suite translated from Eyeling's examples/collatz-1000.n3.
% It enumerates starts N = 1000, 999, ..., 1 by deriving N = 1000 - N0
% from a repeat relation, then querys each full trajectory.
%
% Source N3:
% https://raw.githubusercontent.com/eyereasoner/eyeling/refs/heads/main/examples/collatz-1000.n3

% Output declarations: query/1 selects the relations written to this example's golden output.
% Automatic tabling caches shared suffix trajectories so the 1000 starts do not recompute
% the same Collatz tails hundreds of times.
query(collatzTrajectory(X0, X1)).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.
% The N3 source defines repeat/2 recursively; this Eyepl version uses the
% equivalent bounded generator so the 1000-case regression remains stack-safe.

% Query / query execution of the test suite.
% Generate N in {1000..1} and ask the backward-defined collatz/2 predicate
% for the full trajectory list M.
collatzTrajectory(N, M) :-
  repeat(1000, N0),
  (N is 1000 - N0),
  collatz(N, M).

% Range generator.
% repeat(N, I) enumerates all integers I in the half-open interval [0..N-1].
repeat(N, I) :-
  (Last is N - 1),
  between(0, Last, I).

% Backward Collatz relation.
% collatz(N, M) relates a start value N to its full trajectory list M.
collatz(1, [1]).
collatz(N, [N|J]) :-
  (N > 1),
  (0 is N mod 2),
  (N1 is N // 2),
  collatz(N1, J).
collatz(N, [N|J]) :-
  (N > 1),
  (1 is N mod 2),
  (T is 3 * N),
  (N1 is T + 1),
  collatz(N1, J).
