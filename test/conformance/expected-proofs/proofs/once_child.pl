answer(a).
why(
  answer(a),
  proof(
    goal(answer(a)),
    by(rule("<stdin>", clause(3))),
    bindings([binding("X", a)]),
    uses([
      proof(
        goal(once(choice(a))),
        by(builtin(once, 1)),
        uses([
          proof(
            goal(choice(a)),
            by(fact("<stdin>", clause(1)))
          )
        ])
      )
    ])
  )
).

