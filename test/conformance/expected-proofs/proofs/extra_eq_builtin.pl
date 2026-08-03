answer(eq_builtin, a).
why(
  answer(eq_builtin, a),
  proof(
    goal(answer(eq_builtin, a)),
    by(rule("<stdin>", clause(1))),
    bindings([binding("X", a)]),
    uses([
      proof(
        goal(=(pair(a, b), pair(a, b))),
        by(builtin(=, 2))
      )
    ])
  )
).

