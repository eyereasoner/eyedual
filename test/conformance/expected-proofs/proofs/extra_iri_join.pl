answer(iri_join, '<urn:example:alice>').
why(
  answer(iri_join, '<urn:example:alice>'),
  proof(
    goal(answer(iri_join, '<urn:example:alice>')),
    by(rule("<stdin>", clause(1))),
    bindings([binding("Who", '<urn:example:alice>')]),
    uses([
      proof(
        goal(=('<urn:example:alice>', '<urn:example:alice>')),
        by(builtin(=, 2))
      )
    ])
  )
).

