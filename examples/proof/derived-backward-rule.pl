log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x))).
why(
  log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x))),
  proof(
    goal(log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x)))),
    by(rule("derived-backward-rule.pl", clause(3))),
    uses([
      proof(
        goal(invOf(parentOf, childOf)),
        by(fact("derived-backward-rule.pl", clause(1)))
      )
    ])
  )
).

childOf(bob, alice).
why(
  childOf(bob, alice),
  proof(
    goal(childOf(bob, alice)),
    by(rule("derived-backward-rule.pl", clause(4))),
    bindings([binding("X", bob), binding("Y", alice)]),
    uses([
      proof(
        goal(log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x)))),
        by(rule("derived-backward-rule.pl", clause(3))),
        uses([
          proof(
            goal(invOf(parentOf, childOf)),
            by(fact("derived-backward-rule.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(parentOf(alice, bob)),
        by(fact("derived-backward-rule.pl", clause(2)))
      )
    ])
  )
).

hasParent(bob, alice).
why(
  hasParent(bob, alice),
  proof(
    goal(hasParent(bob, alice)),
    by(rule("derived-backward-rule.pl", clause(5))),
    bindings([binding("X", bob), binding("Y", alice)]),
    uses([
      proof(
        goal(childOf(bob, alice)),
        by(rule("derived-backward-rule.pl", clause(4))),
        bindings([binding("X", bob), binding("Y", alice)]),
        uses([
          proof(
            goal(log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x)))),
            by(rule("derived-backward-rule.pl", clause(3))),
            uses([
              proof(
                goal(invOf(parentOf, childOf)),
                by(fact("derived-backward-rule.pl", clause(1)))
              )
            ])
          ),
          proof(
            goal(parentOf(alice, bob)),
            by(fact("derived-backward-rule.pl", clause(2)))
          )
        ])
      )
    ])
  )
).

