% Integer partition counts by tabled dynamic programming.
%
% partitions(N, K, Count) counts unordered sums of N using parts no larger than K.
% The two recursive branches are the standard include-K / exclude-K split.  Without
% memoization the same (N,K) subproblems are reached many times.
query(partition_answer(X0, X1)).


% One empty sum partitions zero; positive N with K=0 is impossible.
partitions(0, _k, 1).
partitions(N, 0, 0) :- (N > 0).
partitions(N, K, Count) :-
  (N > 0),
  (K > 0),
  (K > N),
  (K1 is K - 1),
  partitions(N, K1, Count).
partitions(N, K, Count) :-
  (N > 0),
  (K > 0),
  (K =< N),
  (Remainder is N - K),
  partitions(Remainder, K, Withk),
  (K1 is K - 1),
  partitions(N, K1, Withoutk),
  (Count is Withk + Withoutk).

% The ordinary partition number p(N) allows all parts up to N.
partition_count(N, Count) :- partitions(N, N, Count).

partition_answer(p_12, Count) :- partition_count(12, Count).
partition_answer(p_15, Count) :- partition_count(15, Count).
partition_answer(p_16_using_parts_at_most_5, Count) :- partitions(16, 5, Count).
partition_answer(cumulative_p_1_to_8, Sum) :- sumall(C, (between(1, 8, N), partition_count(N, C)), Sum).
