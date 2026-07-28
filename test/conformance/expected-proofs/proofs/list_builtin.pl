answer(b).
why(
  answer(b),
  proof(
    goal(answer(b)),
    by(rule("<stdin>", clause(2))),
    bindings([binding("X", b)]),
    uses([
      proof(
        goal(member(b, [a, b])),
        by(rule("<library>", clause(4))),
        bindings([binding("X", b), binding("__anon1", a), binding("Xs", [b])]),
        uses([
          proof(
            goal(member(b, [b])),
            by(fact("<library>", clause(3))),
            bindings([binding("X", b), binding("__anon0", [])])
          )
        ])
      ),
      proof(
        goal(=(b, b)),
        by(builtin(=, 2))
      )
    ])
  )
).

