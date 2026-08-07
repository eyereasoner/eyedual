rdf(iri('https://example.org/sensor1'), iri('https://example.org/reportedBy'), iri('https://example.org/station7'), default_graph).
why(
  rdf(iri('https://example.org/sensor1'), iri('https://example.org/reportedBy'), iri('https://example.org/station7'), default_graph),
  proof(
    goal(rdf(iri('https://example.org/sensor1'), iri('https://example.org/reportedBy'), iri('https://example.org/station7'), default_graph)),
    by(rule("rdf12-trig-graph-join.pl", clause(3))),
    bindings([binding("S", iri('https://example.org/sensor1')), binding("Station", iri('https://example.org/station7')), binding("__anon0", literal('21.5', datatype('http://www.w3.org/2001/XMLSchema#string')))]),
    uses([
      proof(
        goal(rdf(iri('https://example.org/sensorGraph'), iri('https://example.org/reportedBy'), iri('https://example.org/station7'), default_graph)),
        by(fact("rdf12-trig-graph-join.pl", clause(1)))
      ),
      proof(
        goal(rdf(iri('https://example.org/sensor1'), iri('https://example.org/temperature'), literal('21.5', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/sensorGraph'))),
        by(fact("rdf12-trig-graph-join.pl", clause(2)))
      )
    ])
  )
).

