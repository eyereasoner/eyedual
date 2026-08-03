label('<urn:example:a>', "Alice").
why(
  label('<urn:example:a>', "Alice"),
  proof(
    goal(label('<urn:example:a>', "Alice")),
    by(rule("<stdin>", clause(2))),
    bindings([binding("Iri", '<urn:example:a>'), binding("Name", "Alice")]),
    uses([
      proof(
        goal(name('<urn:example:a>', "Alice")),
        by(fact("<stdin>", clause(1)))
      )
    ])
  )
).

