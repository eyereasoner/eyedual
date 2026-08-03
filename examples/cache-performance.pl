% Technology example: cache performance summary.
%
% A service has cache hits and misses with different response latencies. The
% rules compute hit rate and weighted average latency, then classify whether
% the cache is effective.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: hitRate(X0, X1)

%% goal: averageLatency_ms(X0, X1)

%% goal: status(X0, X1)

%% goal: reason(X0, X1)


% cache_sample/5 contains hits, misses, and the two latency classes; threshold/3
% contains the operational targets used by the status rule.
cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0).
threshold(api_cache, minimum_hit_rate, 0.80).
threshold(api_cache, maximum_average_latency_ms, 20.0).

% The rules compute total requests, hit rate, and weighted latency before
% applying both acceptance thresholds together.
total_requests(Cache, Total) :-
  cache_sample(Cache, Hits, Misses, _hitlatency, _misslatency),
  (Total is Hits + Misses).

hit_rate(Cache, Rate) :-
  cache_sample(Cache, Hits, _misses, _hitlatency, _misslatency),
  total_requests(Cache, Total),
  (Rate is Hits / Total).

average_latency(Cache, Average) :-
  cache_sample(Cache, Hits, Misses, Hitlatency, Misslatency),
  (Hitcost is Hits * Hitlatency),
  (Misscost is Misses * Misslatency),
  (Totalcost is Hitcost + Misscost),
  total_requests(Cache, Total),
  (Average is Totalcost / Total).

cache_effective(Cache) :-
  hit_rate(Cache, Rate),
  threshold(Cache, minimum_hit_rate, Minimumrate),
  (Rate > Minimumrate),
  average_latency(Cache, Average),
  threshold(Cache, maximum_average_latency_ms, Maximumlatency),
  (Average < Maximumlatency).

hitRate(Cache, Rate) :-
  hit_rate(Cache, Rate).

averageLatency_ms(Cache, Average) :-
  average_latency(Cache, Average).

status(Cache, cache_effective) :-
  cache_effective(Cache).

reason(Cache, "hit rate is above target and average latency is below limit") :-
  cache_effective(Cache).
