answer(once_member, a).
why(
  answer(once_member, a),
  proof(
    goal(answer(once_member, a)),
    by(rule("<stdin>", clause(2))),
    bindings([binding("X", a)]),
    uses([
      proof(
        goal(once(member(a, [a, b, c]))),
        by(builtin(once, 1)),
        uses([
          proof(
            goal(member(a, [a, b, c])),
            by(builtin(member, 2))
          )
        ])
      )
    ])
  )
).

