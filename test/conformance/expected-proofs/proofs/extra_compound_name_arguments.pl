answer(compound_name_arguments, box, "ab").
why(
  answer(compound_name_arguments, box, "ab"),
  proof(
    goal(answer(compound_name_arguments, box, "ab")),
    by(rule("<stdin>", clause(1))),
    bindings([binding("Name", box), binding("Args", "ab")]),
    uses([
      proof(
        goal('=..'(box(a, b), [box, a, b])),
        by(builtin('=..', 2))
      )
    ])
  )
).

