answer(ok).
why(
  answer(ok),
  proof(
    goal(answer(ok)),
    by(rule("<stdin>", clause(2))),
    uses([
      proof(
        goal('\\+'(known(b))),
        by(builtin('\\+', 1))
      )
    ])
  )
).

