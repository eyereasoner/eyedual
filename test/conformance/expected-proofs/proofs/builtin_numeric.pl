answer(5).
why(
  answer(5),
  proof(
    goal(answer(5)),
    by(rule("<stdin>", clause(1))),
    bindings([binding("X", 5)]),
    uses([
      proof(
        goal(is(5, '+'(2, 3))),
        by(builtin(is, 2))
      )
    ])
  )
).

