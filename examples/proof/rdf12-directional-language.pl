rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('مرحبا', lang(ar, rtl)), default_graph).
why(
  rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('مرحبا', lang(ar, rtl)), default_graph),
  proof(
    goal(rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('مرحبا', lang(ar, rtl)), default_graph)),
    by(rule("rdf12-directional-language.pl", clause(3))),
    bindings([binding("S", iri('https://example.org/welcome')), binding("Label", literal('مرحبا', lang(ar, rtl))), binding("G", default_graph)]),
    uses([
      proof(
        goal(rdf(iri('https://example.org/welcome'), iri('https://example.org/label'), literal('مرحبا', lang(ar, rtl)), default_graph)),
        by(fact("rdf12-directional-language.pl", clause(1)))
      )
    ])
  )
).

rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('Welcome', lang(en, ltr)), default_graph).
why(
  rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('Welcome', lang(en, ltr)), default_graph),
  proof(
    goal(rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('Welcome', lang(en, ltr)), default_graph)),
    by(rule("rdf12-directional-language.pl", clause(3))),
    bindings([binding("S", iri('https://example.org/welcome')), binding("Label", literal('Welcome', lang(en, ltr))), binding("G", default_graph)]),
    uses([
      proof(
        goal(rdf(iri('https://example.org/welcome'), iri('https://example.org/label'), literal('Welcome', lang(en, ltr)), default_graph)),
        by(fact("rdf12-directional-language.pl", clause(2)))
      )
    ])
  )
).

