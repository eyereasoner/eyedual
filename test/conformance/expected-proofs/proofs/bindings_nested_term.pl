answer(pair(a, "bc")).
why(
  answer(pair(a, "bc")),
  proof(
    goal(answer(pair(a, "bc"))),
    by(rule("<stdin>", clause(2))),
    bindings([binding("Term", pair(a, "bc"))]),
    uses([
      proof(
        goal(source(pair(a, "bc"))),
        by(fact("<stdin>", clause(1)))
      )
    ])
  )
).

