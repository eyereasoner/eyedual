answer(b).
why(
  answer(b),
  proof(
    goal(answer(b)),
    by(rule("<stdin>", clause(1))),
    bindings([binding("X", b)]),
    uses([
      proof(
        goal(member(b, "ab")),
        by(library(member, 2))
      ),
      proof(
        goal(=(b, b)),
        by(builtin(=, 2))
      )
    ])
  )
).

