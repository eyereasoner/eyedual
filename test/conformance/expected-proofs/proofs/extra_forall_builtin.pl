answer(forall_builtin).
why(
  answer(forall_builtin),
  proof(
    goal(answer(forall_builtin)),
    by(rule("<stdin>", clause(2))),
    uses([
      proof(
        goal('\\+'(forall_counterexample)),
        by(builtin('\\+', 1))
      )
    ])
  )
).

