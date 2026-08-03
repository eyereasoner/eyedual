errorRate(canary42, 0.014999999999999999).
why(
  errorRate(canary42, 0.014999999999999999),
  proof(
    goal(errorRate(canary42, 0.014999999999999999)),
    by(rule("canary-release.pl", clause(8))),
    bindings([binding("Release", canary42), binding("Rate", 0.014999999999999999)]),
    uses([
      proof(
        goal(error_rate(canary42, 0.014999999999999999)),
        by(rule("canary-release.pl", clause(4))),
        bindings([binding("Release", canary42), binding("Rate", 0.014999999999999999), binding("Requests", 5000.0), binding("Errors", 75.0), binding("_p95latency", 180.0)]),
        uses([
          proof(
            goal(canary(canary42, 5000.0, 75.0, 180.0)),
            by(fact("canary-release.pl", clause(1)))
          ),
          proof(
            goal(is(0.014999999999999999, /(75.0, 5000.0))),
            by(builtin(is, 2))
          )
        ])
      )
    ])
  )
).

p95Latency_ms(canary42, 180.0).
why(
  p95Latency_ms(canary42, 180.0),
  proof(
    goal(p95Latency_ms(canary42, 180.0)),
    by(rule("canary-release.pl", clause(9))),
    bindings([binding("Release", canary42), binding("P95latency", 180.0), binding("_requests", 5000.0), binding("_errors", 75.0)]),
    uses([
      proof(
        goal(canary(canary42, 5000.0, 75.0, 180.0)),
        by(fact("canary-release.pl", clause(1)))
      )
    ])
  )
).

latencyCheck(canary42, ok).
why(
  latencyCheck(canary42, ok),
  proof(
    goal(latencyCheck(canary42, ok)),
    by(rule("canary-release.pl", clause(10))),
    bindings([binding("Release", canary42)]),
    uses([
      proof(
        goal(latency_ok(canary42)),
        by(rule("canary-release.pl", clause(5))),
        bindings([binding("Release", canary42), binding("_requests", 5000.0), binding("_errors", 75.0), binding("P95latency", 180.0), binding("Maximum", 200.0)]),
        uses([
          proof(
            goal(canary(canary42, 5000.0, 75.0, 180.0)),
            by(fact("canary-release.pl", clause(1)))
          ),
          proof(
            goal(threshold(canary42, maximum_p95_latency_ms, 200.0)),
            by(fact("canary-release.pl", clause(3)))
          ),
          proof(
            goal(<(180.0, 200.0)),
            by(builtin(<, 2))
          )
        ])
      )
    ])
  )
).

status(canary42, rollback_recommended).
why(
  status(canary42, rollback_recommended),
  proof(
    goal(status(canary42, rollback_recommended)),
    by(rule("canary-release.pl", clause(11))),
    bindings([binding("Release", canary42)]),
    uses([
      proof(
        goal(rollback_recommended(canary42)),
        by(rule("canary-release.pl", clause(7))),
        bindings([binding("Release", canary42)]),
        uses([
          proof(
            goal(error_budget_exceeded(canary42)),
            by(rule("canary-release.pl", clause(6))),
            bindings([binding("Release", canary42), binding("Rate", 0.014999999999999999), binding("Maximum", 0.01)]),
            uses([
              proof(
                goal(error_rate(canary42, 0.014999999999999999)),
                by(rule("canary-release.pl", clause(4))),
                bindings([binding("Release", canary42), binding("Rate", 0.014999999999999999), binding("Requests", 5000.0), binding("Errors", 75.0), binding("_p95latency", 180.0)]),
                uses([
                  proof(
                    goal(canary(canary42, 5000.0, 75.0, 180.0)),
                    by(fact("canary-release.pl", clause(1)))
                  ),
                  proof(
                    goal(is(0.014999999999999999, /(75.0, 5000.0))),
                    by(builtin(is, 2))
                  )
                ])
              ),
              proof(
                goal(threshold(canary42, maximum_error_rate, 0.01)),
                by(fact("canary-release.pl", clause(2)))
              ),
              proof(
                goal(>(0.014999999999999999, 0.01)),
                by(builtin(>, 2))
              )
            ])
          )
        ])
      )
    ])
  )
).

reason(canary42, "canary error rate exceeds the allowed budget").
why(
  reason(canary42, "canary error rate exceeds the allowed budget"),
  proof(
    goal(reason(canary42, "canary error rate exceeds the allowed budget")),
    by(rule("canary-release.pl", clause(12))),
    bindings([binding("Release", canary42)]),
    uses([
      proof(
        goal(rollback_recommended(canary42)),
        by(rule("canary-release.pl", clause(7))),
        bindings([binding("Release", canary42)]),
        uses([
          proof(
            goal(error_budget_exceeded(canary42)),
            by(rule("canary-release.pl", clause(6))),
            bindings([binding("Release", canary42), binding("Rate", 0.014999999999999999), binding("Maximum", 0.01)]),
            uses([
              proof(
                goal(error_rate(canary42, 0.014999999999999999)),
                by(rule("canary-release.pl", clause(4))),
                bindings([binding("Release", canary42), binding("Rate", 0.014999999999999999), binding("Requests", 5000.0), binding("Errors", 75.0), binding("_p95latency", 180.0)]),
                uses([
                  proof(
                    goal(canary(canary42, 5000.0, 75.0, 180.0)),
                    by(fact("canary-release.pl", clause(1)))
                  ),
                  proof(
                    goal(is(0.014999999999999999, /(75.0, 5000.0))),
                    by(builtin(is, 2))
                  )
                ])
              ),
              proof(
                goal(threshold(canary42, maximum_error_rate, 0.01)),
                by(fact("canary-release.pl", clause(2)))
              ),
              proof(
                goal(>(0.014999999999999999, 0.01)),
                by(builtin(>, 2))
              )
            ])
          )
        ])
      )
    ])
  )
).

