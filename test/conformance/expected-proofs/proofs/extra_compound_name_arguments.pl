answer(compound_name_arguments, box, [a, b]).
why(
  answer(compound_name_arguments, box, [a, b]),
  proof(
    goal(answer(compound_name_arguments, box, [a, b])),
    by(rule("<stdin>", clause(1))),
    bindings([binding("Name", box), binding("Args", [a, b])]),
    uses([
      proof(
        goal('=..'(box(a, b), [box, a, b])),
        by(builtin('=..', 2))
      )
    ])
  )
).

