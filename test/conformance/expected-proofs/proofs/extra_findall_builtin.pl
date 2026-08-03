answer(findall_builtin, [a, b]).
why(
  answer(findall_builtin, [a, b]),
  proof(
    goal(answer(findall_builtin, [a, b])),
    by(rule("<stdin>", clause(3))),
    bindings([binding("Bag", [a, b])]),
    uses([
      proof(
        goal(findall(X, item(X), [a, b])),
        by(builtin(findall, 3))
      )
    ])
  )
).

