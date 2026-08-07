rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), default_graph).
why(
  rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), default_graph),
  proof(
    goal(rdf(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol'), default_graph)),
    by(rule("rdf12-triple-term.pl", clause(2))),
    bindings([binding("S", iri('https://example.org/bob')), binding("O", iri('https://example.org/carol')), binding("G", default_graph), binding("__anon0", iri('https://example.org/alice'))]),
    uses([
      proof(
        goal(rdf(iri('https://example.org/alice'), iri('https://example.org/claims'), triple(iri('https://example.org/bob'), iri('https://example.org/knows'), iri('https://example.org/carol')), default_graph)),
        by(fact("rdf12-triple-term.pl", clause(1)))
      )
    ])
  )
).

