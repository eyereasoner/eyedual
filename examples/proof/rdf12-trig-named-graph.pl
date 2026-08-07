rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/bob'), iri('https://example.org/family')).
why(
  rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/bob'), iri('https://example.org/family')),
  proof(
    goal(rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/bob'), iri('https://example.org/family'))),
    by(rule("rdf12-trig-named-graph.pl", clause(3))),
    bindings([binding("S", iri('https://example.org/alice')), binding("O", iri('https://example.org/bob')), binding("G", iri('https://example.org/family'))]),
    uses([
      proof(
        goal(rdf(iri('https://example.org/alice'), iri('https://example.org/parent'), iri('https://example.org/bob'), iri('https://example.org/family'))),
        by(fact("rdf12-trig-named-graph.pl", clause(1)))
      )
    ])
  )
).

rdf(iri('https://example.org/bob'), iri('https://example.org/ancestor'), iri('https://example.org/carol'), iri('https://example.org/family')).
why(
  rdf(iri('https://example.org/bob'), iri('https://example.org/ancestor'), iri('https://example.org/carol'), iri('https://example.org/family')),
  proof(
    goal(rdf(iri('https://example.org/bob'), iri('https://example.org/ancestor'), iri('https://example.org/carol'), iri('https://example.org/family'))),
    by(rule("rdf12-trig-named-graph.pl", clause(3))),
    bindings([binding("S", iri('https://example.org/bob')), binding("O", iri('https://example.org/carol')), binding("G", iri('https://example.org/family'))]),
    uses([
      proof(
        goal(rdf(iri('https://example.org/bob'), iri('https://example.org/parent'), iri('https://example.org/carol'), iri('https://example.org/family'))),
        by(fact("rdf12-trig-named-graph.pl", clause(2)))
      )
    ])
  )
).

rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/carol'), iri('https://example.org/family')).
why(
  rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/carol'), iri('https://example.org/family')),
  proof(
    goal(rdf(iri('https://example.org/alice'), iri('https://example.org/ancestor'), iri('https://example.org/carol'), iri('https://example.org/family'))),
    by(rule("rdf12-trig-named-graph.pl", clause(4))),
    bindings([binding("S", iri('https://example.org/alice')), binding("O", iri('https://example.org/carol')), binding("G", iri('https://example.org/family')), binding("M", iri('https://example.org/bob'))]),
    uses([
      proof(
        goal(rdf(iri('https://example.org/alice'), iri('https://example.org/parent'), iri('https://example.org/bob'), iri('https://example.org/family'))),
        by(fact("rdf12-trig-named-graph.pl", clause(1)))
      ),
      proof(
        goal(rdf(iri('https://example.org/bob'), iri('https://example.org/parent'), iri('https://example.org/carol'), iri('https://example.org/family'))),
        by(fact("rdf12-trig-named-graph.pl", clause(2)))
      )
    ])
  )
).

