log_implies(type(var(y), dog), holds_result(test, true)).
why(
  log_implies(type(var(y), dog), holds_result(test, true)),
  proof(
    goal(log_implies(type(var(y), dog), holds_result(test, true))),
    by(rule("derived-rule.pl", clause(6))),
    bindings([binding("_x", minka)]),
    uses([
      proof(
        goal(type(minka, cat)),
        by(fact("derived-rule.pl", clause(4)))
      )
    ])
  )
).

holds_result(test, true).
why(
  holds_result(test, true),
  proof(
    goal(holds_result(test, true)),
    by(rule("derived-rule.pl", clause(7))),
    bindings([binding("_y", charly)]),
    uses([
      proof(
        goal(log_implies(type(var(y), dog), holds_result(test, true))),
        by(rule("derived-rule.pl", clause(6))),
        bindings([binding("_x", minka)]),
        uses([
          proof(
            goal(type(minka, cat)),
            by(fact("derived-rule.pl", clause(4)))
          )
        ])
      ),
      proof(
        goal(type(charly, dog)),
        by(fact("derived-rule.pl", clause(5)))
      )
    ])
  )
).

