holds_result(socrates, human_witness(socrates)).
why(
  holds_result(socrates, human_witness(socrates)),
  proof(
    goal(holds_result(socrates, human_witness(socrates))),
    by(rule("existential-rule.pl", clause(3))),
    bindings([binding("Person", socrates)]),
    uses([
      proof(
        goal(type(socrates, human)),
        by(fact("existential-rule.pl", clause(1)))
      )
    ])
  )
).

holds_result(plato, human_witness(plato)).
why(
  holds_result(plato, human_witness(plato)),
  proof(
    goal(holds_result(plato, human_witness(plato))),
    by(rule("existential-rule.pl", clause(3))),
    bindings([binding("Person", plato)]),
    uses([
      proof(
        goal(type(plato, human)),
        by(fact("existential-rule.pl", clause(2)))
      )
    ])
  )
).

