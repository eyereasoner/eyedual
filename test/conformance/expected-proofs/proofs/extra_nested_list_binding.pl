answer(nested_list_binding, "c").
why(
  answer(nested_list_binding, "c"),
  proof(
    goal(answer(nested_list_binding, "c")),
    by(rule("<stdin>", clause(1))),
    bindings([binding("Tail", "c")]),
    uses([
      proof(
        goal(=("abc", "abc")),
        by(builtin(=, 2))
      )
    ])
  )
).

