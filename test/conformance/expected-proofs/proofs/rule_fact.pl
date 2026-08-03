answer(ok).
why(
  answer(ok),
  proof(
    goal(answer(ok)),
    by(rule("<stdin>", clause(2))),
    bindings([binding("X", ok)]),
    uses([
      proof(
        goal(seed(ok)),
        by(fact("<stdin>", clause(1)))
      )
    ])
  )
).

