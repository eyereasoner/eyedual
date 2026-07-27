answer(nested_list_binding, [c]).
why(
  answer(nested_list_binding, [c]),
  proof(
    goal(answer(nested_list_binding, [c])),
    by(rule("<stdin>", clause(2))),
    bindings([binding("Tail", [c])]),
    uses([
      proof(
        goal(=([a, b, c], [a, b, c])),
        by(builtin(=, 2))
      )
    ])
  )
).

