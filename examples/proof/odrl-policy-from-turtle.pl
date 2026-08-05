odrl_policy_decision(permit(use, research, dataset)).
why(
  odrl_policy_decision(permit(use, research, dataset)),
  proof(
    goal(odrl_policy_decision(permit(use, research, dataset))),
    by(rule("odrl-policy-from-turtle.pl", clause(8))),
    bindings([binding("Permission", iri("https://example.org/permission")), binding("Constraint", iri("https://example.org/purpose-constraint"))]),
    uses([
      proof(
        goal(rdf(iri("https://example.org/policy"), iri("http://www.w3.org/ns/odrl/2/permission"), iri("https://example.org/permission"), default_graph)),
        by(fact("odrl-policy-from-turtle.pl", clause(1)))
      ),
      proof(
        goal(rdf(iri("https://example.org/permission"), iri("http://www.w3.org/ns/odrl/2/target"), iri("https://example.org/dataset"), default_graph)),
        by(fact("odrl-policy-from-turtle.pl", clause(2)))
      ),
      proof(
        goal(rdf(iri("https://example.org/permission"), iri("http://www.w3.org/ns/odrl/2/action"), iri("http://www.w3.org/ns/odrl/2/use"), default_graph)),
        by(fact("odrl-policy-from-turtle.pl", clause(3)))
      ),
      proof(
        goal(rdf(iri("https://example.org/permission"), iri("http://www.w3.org/ns/odrl/2/constraint"), iri("https://example.org/purpose-constraint"), default_graph)),
        by(fact("odrl-policy-from-turtle.pl", clause(4)))
      ),
      proof(
        goal(rdf(iri("https://example.org/purpose-constraint"), iri("http://www.w3.org/ns/odrl/2/leftOperand"), iri("http://www.w3.org/ns/odrl/2/purpose"), default_graph)),
        by(fact("odrl-policy-from-turtle.pl", clause(5)))
      ),
      proof(
        goal(rdf(iri("https://example.org/purpose-constraint"), iri("http://www.w3.org/ns/odrl/2/operator"), iri("http://www.w3.org/ns/odrl/2/eq"), default_graph)),
        by(fact("odrl-policy-from-turtle.pl", clause(6)))
      ),
      proof(
        goal(rdf(iri("https://example.org/purpose-constraint"), iri("http://www.w3.org/ns/odrl/2/rightOperand"), iri("https://example.org/research"), default_graph)),
        by(fact("odrl-policy-from-turtle.pl", clause(7)))
      )
    ])
  )
).

