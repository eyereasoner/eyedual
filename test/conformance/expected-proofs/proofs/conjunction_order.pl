answer(ok).
why(
  answer(ok),
  proof(
    goal(answer(ok)),
    by(rule("<stdin>", clause(3))),
    uses([
      proof(
        goal(left(ok)),
        by(fact("<stdin>", clause(1)))
      ),
      proof(
        goal(right(ok)),
        by(fact("<stdin>", clause(2)))
      )
    ])
  )
).

