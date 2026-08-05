rdf(iri("https://example.org/bob"), iri("https://example.org/knows"), iri("https://example.org/carol"), iri("https://example.org/claimsGraph")).
why(
  rdf(iri("https://example.org/bob"), iri("https://example.org/knows"), iri("https://example.org/carol"), iri("https://example.org/claimsGraph")),
  proof(
    goal(rdf(iri("https://example.org/bob"), iri("https://example.org/knows"), iri("https://example.org/carol"), iri("https://example.org/claimsGraph"))),
    by(rule("rdf12-trig-triple-term.pl", clause(2))),
    bindings([binding("S", iri("https://example.org/bob")), binding("O", iri("https://example.org/carol")), binding("G", iri("https://example.org/claimsGraph")), binding("__anon0", iri("https://example.org/alice"))]),
    uses([
      proof(
        goal(rdf(iri("https://example.org/alice"), iri("https://example.org/claims"), triple(iri("https://example.org/bob"), iri("https://example.org/knows"), iri("https://example.org/carol")), iri("https://example.org/claimsGraph"))),
        by(fact("rdf12-trig-triple-term.pl", clause(1)))
      )
    ])
  )
).

