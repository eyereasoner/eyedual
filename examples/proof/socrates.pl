type(socrates, mortal).
why(
  type(socrates, mortal),
  proof(
    goal(type(socrates, mortal)),
    by(rule("socrates.pl", clause(2))),
    bindings([binding("X", socrates)]),
    uses([
      proof(
        goal(type(socrates, man)),
        by(fact("socrates.pl", clause(1)))
      )
    ])
  )
).

holds_result(test, true).
why(
  holds_result(test, true),
  proof(
    goal(holds_result(test, true)),
    by(rule("socrates.pl", clause(3))),
    uses([
      proof(
        goal(type(socrates, mortal)),
        by(rule("socrates.pl", clause(2))),
        bindings([binding("X", socrates)]),
        uses([
          proof(
            goal(type(socrates, man)),
            by(fact("socrates.pl", clause(1)))
          )
        ])
      )
    ])
  )
).

