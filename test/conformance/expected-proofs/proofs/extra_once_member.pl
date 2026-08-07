answer(once_member, a).
why(
  answer(once_member, a),
  proof(
    goal(answer(once_member, a)),
    by(rule("<stdin>", clause(1))),
    bindings([binding("X", a)]),
    uses([
      proof(
        goal(once(member(a, "abc"))),
        by(builtin(once, 1)),
        uses([
          proof(
            goal(member(a, "abc")),
            by(library(member, 2))
          )
        ])
      )
    ])
  )
).

