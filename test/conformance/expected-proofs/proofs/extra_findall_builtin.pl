answer(findall_builtin, "ab").
why(
  answer(findall_builtin, "ab"),
  proof(
    goal(answer(findall_builtin, "ab")),
    by(rule("<stdin>", clause(3))),
    bindings([binding("Bag", "ab")]),
    uses([
      proof(
        goal(findall(X, item(X), "ab")),
        by(builtin(findall, 3))
      )
    ])
  )
).

