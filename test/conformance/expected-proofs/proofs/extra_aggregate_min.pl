answer(aggregate_min, 1, a).
why(
  answer(aggregate_min, 1, a),
  proof(
    goal(answer(aggregate_min, 1, a)),
    by(rule("<stdin>", clause(3))),
    bindings([binding("Key", 1), binding("Value", a)]),
    uses([
      proof(
        goal(aggregate_min(Key, Value, score(Key, Value), 1, a)),
        by(library(aggregate_min, 5))
      )
    ])
  )
).

