holds_result(test, holds_result(joe, good(cobbler))).
why(
  holds_result(test, holds_result(joe, good(cobbler))),
  proof(
    goal(holds_result(test, holds_result(joe, good(cobbler)))),
    by(rule("good-cobbler.pl", clause(2))),
    bindings([binding("X", joe), binding("Y", cobbler)]),
    uses([
      proof(
        goal(assertedIs(joe, good(cobbler))),
        by(fact("good-cobbler.pl", clause(1)))
      )
    ])
  )
).

