answer(aggregate_min, 1, a).
why(
  answer(aggregate_min, 1, a),
  proof(
    goal(answer(aggregate_min, 1, a)),
    by(rule("<stdin>", clause(4))),
    bindings([binding("Key", 1), binding("Value", a)]),
    uses([
      proof(
        goal(aggregate_min(K, V, score(K, V), 1, a)),
        by(builtin(aggregate_min, 5))
      )
    ])
  )
).

