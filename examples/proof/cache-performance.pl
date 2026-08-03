hitRate(api_cache, 0.85999999999999999).
why(
  hitRate(api_cache, 0.85999999999999999),
  proof(
    goal(hitRate(api_cache, 0.85999999999999999)),
    by(rule("cache-performance.pl", clause(8))),
    bindings([binding("Cache", api_cache), binding("Rate", 0.85999999999999999)]),
    uses([
      proof(
        goal(hit_rate(api_cache, 0.85999999999999999)),
        by(rule("cache-performance.pl", clause(5))),
        bindings([binding("Cache", api_cache), binding("Rate", 0.85999999999999999), binding("Hits", 8600.0), binding("_misses", 1400.0), binding("_hitlatency", 5.0), binding("_misslatency", 80.0), binding("Total", 10000.0)]),
        uses([
          proof(
            goal(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0)),
            by(fact("cache-performance.pl", clause(1)))
          ),
          proof(
            goal(total_requests(api_cache, 10000.0)),
            by(rule("cache-performance.pl", clause(4))),
            bindings([binding("Cache", api_cache), binding("Total", 10000.0), binding("Hits", 8600.0), binding("Misses", 1400.0), binding("_hitlatency", 5.0), binding("_misslatency", 80.0)]),
            uses([
              proof(
                goal(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0)),
                by(fact("cache-performance.pl", clause(1)))
              ),
              proof(
                goal(is(10000.0, '+'(8600.0, 1400.0))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(is(0.85999999999999999, /(8600.0, 10000.0))),
            by(builtin(is, 2))
          )
        ])
      )
    ])
  )
).

averageLatency_ms(api_cache, 15.5).
why(
  averageLatency_ms(api_cache, 15.5),
  proof(
    goal(averageLatency_ms(api_cache, 15.5)),
    by(rule("cache-performance.pl", clause(9))),
    bindings([binding("Cache", api_cache), binding("Average", 15.5)]),
    uses([
      proof(
        goal(average_latency(api_cache, 15.5)),
        by(rule("cache-performance.pl", clause(6))),
        bindings([binding("Cache", api_cache), binding("Average", 15.5), binding("Hits", 8600.0), binding("Misses", 1400.0), binding("Hitlatency", 5.0), binding("Misslatency", 80.0), binding("Hitcost", 43000.0), binding("Misscost", 112000.0), binding("Totalcost", 155000.0), binding("Total", 10000.0)]),
        uses([
          proof(
            goal(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0)),
            by(fact("cache-performance.pl", clause(1)))
          ),
          proof(
            goal(is(43000.0, *(8600.0, 5.0))),
            by(builtin(is, 2))
          ),
          proof(
            goal(is(112000.0, *(1400.0, 80.0))),
            by(builtin(is, 2))
          ),
          proof(
            goal(is(155000.0, '+'(43000.0, 112000.0))),
            by(builtin(is, 2))
          ),
          proof(
            goal(total_requests(api_cache, 10000.0)),
            by(rule("cache-performance.pl", clause(4))),
            bindings([binding("Cache", api_cache), binding("Total", 10000.0), binding("Hits", 8600.0), binding("Misses", 1400.0), binding("_hitlatency", 5.0), binding("_misslatency", 80.0)]),
            uses([
              proof(
                goal(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0)),
                by(fact("cache-performance.pl", clause(1)))
              ),
              proof(
                goal(is(10000.0, '+'(8600.0, 1400.0))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(is(15.5, /(155000.0, 10000.0))),
            by(builtin(is, 2))
          )
        ])
      )
    ])
  )
).

status(api_cache, cache_effective).
why(
  status(api_cache, cache_effective),
  proof(
    goal(status(api_cache, cache_effective)),
    by(rule("cache-performance.pl", clause(10))),
    bindings([binding("Cache", api_cache)]),
    uses([
      proof(
        goal(cache_effective(api_cache)),
        by(rule("cache-performance.pl", clause(7))),
        bindings([binding("Cache", api_cache), binding("Rate", 0.85999999999999999), binding("Minimumrate", 0.80), binding("Average", 15.5), binding("Maximumlatency", 20.0)]),
        uses([
          proof(
            goal(hit_rate(api_cache, 0.85999999999999999)),
            by(rule("cache-performance.pl", clause(5))),
            bindings([binding("Cache", api_cache), binding("Rate", 0.85999999999999999), binding("Hits", 8600.0), binding("_misses", 1400.0), binding("_hitlatency", 5.0), binding("_misslatency", 80.0), binding("Total", 10000.0)]),
            uses([
              proof(
                goal(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0)),
                by(fact("cache-performance.pl", clause(1)))
              ),
              proof(
                goal(total_requests(api_cache, 10000.0)),
                by(rule("cache-performance.pl", clause(4))),
                bindings([binding("Cache", api_cache), binding("Total", 10000.0), binding("Hits", 8600.0), binding("Misses", 1400.0), binding("_hitlatency", 5.0), binding("_misslatency", 80.0)]),
                uses([
                  proof(
                    goal(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0)),
                    by(fact("cache-performance.pl", clause(1)))
                  ),
                  proof(
                    goal(is(10000.0, '+'(8600.0, 1400.0))),
                    by(builtin(is, 2))
                  )
                ])
              ),
              proof(
                goal(is(0.85999999999999999, /(8600.0, 10000.0))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(threshold(api_cache, minimum_hit_rate, 0.80)),
            by(fact("cache-performance.pl", clause(2)))
          ),
          proof(
            goal(>(0.85999999999999999, 0.80)),
            by(builtin(>, 2))
          ),
          proof(
            goal(average_latency(api_cache, 15.5)),
            by(rule("cache-performance.pl", clause(6))),
            bindings([binding("Cache", api_cache), binding("Average", 15.5), binding("Hits", 8600.0), binding("Misses", 1400.0), binding("Hitlatency", 5.0), binding("Misslatency", 80.0), binding("Hitcost", 43000.0), binding("Misscost", 112000.0), binding("Totalcost", 155000.0), binding("Total", 10000.0)]),
            uses([
              proof(
                goal(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0)),
                by(fact("cache-performance.pl", clause(1)))
              ),
              proof(
                goal(is(43000.0, *(8600.0, 5.0))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(112000.0, *(1400.0, 80.0))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(155000.0, '+'(43000.0, 112000.0))),
                by(builtin(is, 2))
              ),
              proof(
                goal(total_requests(api_cache, 10000.0)),
                by(rule("cache-performance.pl", clause(4))),
                bindings([binding("Cache", api_cache), binding("Total", 10000.0), binding("Hits", 8600.0), binding("Misses", 1400.0), binding("_hitlatency", 5.0), binding("_misslatency", 80.0)]),
                uses([
                  proof(
                    goal(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0)),
                    by(fact("cache-performance.pl", clause(1)))
                  ),
                  proof(
                    goal(is(10000.0, '+'(8600.0, 1400.0))),
                    by(builtin(is, 2))
                  )
                ])
              ),
              proof(
                goal(is(15.5, /(155000.0, 10000.0))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(threshold(api_cache, maximum_average_latency_ms, 20.0)),
            by(fact("cache-performance.pl", clause(3)))
          ),
          proof(
            goal(<(15.5, 20.0)),
            by(builtin(<, 2))
          )
        ])
      )
    ])
  )
).

reason(api_cache, "hit rate is above target and average latency is below limit").
why(
  reason(api_cache, "hit rate is above target and average latency is below limit"),
  proof(
    goal(reason(api_cache, "hit rate is above target and average latency is below limit")),
    by(rule("cache-performance.pl", clause(11))),
    bindings([binding("Cache", api_cache)]),
    uses([
      proof(
        goal(cache_effective(api_cache)),
        by(rule("cache-performance.pl", clause(7))),
        bindings([binding("Cache", api_cache), binding("Rate", 0.85999999999999999), binding("Minimumrate", 0.80), binding("Average", 15.5), binding("Maximumlatency", 20.0)]),
        uses([
          proof(
            goal(hit_rate(api_cache, 0.85999999999999999)),
            by(rule("cache-performance.pl", clause(5))),
            bindings([binding("Cache", api_cache), binding("Rate", 0.85999999999999999), binding("Hits", 8600.0), binding("_misses", 1400.0), binding("_hitlatency", 5.0), binding("_misslatency", 80.0), binding("Total", 10000.0)]),
            uses([
              proof(
                goal(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0)),
                by(fact("cache-performance.pl", clause(1)))
              ),
              proof(
                goal(total_requests(api_cache, 10000.0)),
                by(rule("cache-performance.pl", clause(4))),
                bindings([binding("Cache", api_cache), binding("Total", 10000.0), binding("Hits", 8600.0), binding("Misses", 1400.0), binding("_hitlatency", 5.0), binding("_misslatency", 80.0)]),
                uses([
                  proof(
                    goal(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0)),
                    by(fact("cache-performance.pl", clause(1)))
                  ),
                  proof(
                    goal(is(10000.0, '+'(8600.0, 1400.0))),
                    by(builtin(is, 2))
                  )
                ])
              ),
              proof(
                goal(is(0.85999999999999999, /(8600.0, 10000.0))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(threshold(api_cache, minimum_hit_rate, 0.80)),
            by(fact("cache-performance.pl", clause(2)))
          ),
          proof(
            goal(>(0.85999999999999999, 0.80)),
            by(builtin(>, 2))
          ),
          proof(
            goal(average_latency(api_cache, 15.5)),
            by(rule("cache-performance.pl", clause(6))),
            bindings([binding("Cache", api_cache), binding("Average", 15.5), binding("Hits", 8600.0), binding("Misses", 1400.0), binding("Hitlatency", 5.0), binding("Misslatency", 80.0), binding("Hitcost", 43000.0), binding("Misscost", 112000.0), binding("Totalcost", 155000.0), binding("Total", 10000.0)]),
            uses([
              proof(
                goal(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0)),
                by(fact("cache-performance.pl", clause(1)))
              ),
              proof(
                goal(is(43000.0, *(8600.0, 5.0))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(112000.0, *(1400.0, 80.0))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(155000.0, '+'(43000.0, 112000.0))),
                by(builtin(is, 2))
              ),
              proof(
                goal(total_requests(api_cache, 10000.0)),
                by(rule("cache-performance.pl", clause(4))),
                bindings([binding("Cache", api_cache), binding("Total", 10000.0), binding("Hits", 8600.0), binding("Misses", 1400.0), binding("_hitlatency", 5.0), binding("_misslatency", 80.0)]),
                uses([
                  proof(
                    goal(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0)),
                    by(fact("cache-performance.pl", clause(1)))
                  ),
                  proof(
                    goal(is(10000.0, '+'(8600.0, 1400.0))),
                    by(builtin(is, 2))
                  )
                ])
              ),
              proof(
                goal(is(15.5, /(155000.0, 10000.0))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(threshold(api_cache, maximum_average_latency_ms, 20.0)),
            by(fact("cache-performance.pl", clause(3)))
          ),
          proof(
            goal(<(15.5, 20.0)),
            by(builtin(<, 2))
          )
        ])
      )
    ])
  )
).

