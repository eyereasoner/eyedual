weighted_interval_answer(candidate_count, 8).
why(
  weighted_interval_answer(candidate_count, 8),
  proof(
    goal(weighted_interval_answer(candidate_count, 8)),
    by(rule("weighted-interval-scheduling.pl", clause(20))),
    bindings([binding("Count", 8)]),
    uses([
      proof(
        goal(countall(interval(_i, _start, _finish, _value), 8)),
        by(builtin(countall, 2))
      )
    ])
  )
).

