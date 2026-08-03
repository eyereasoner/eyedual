isIndeedMoreInterestingThan(5, 3).
why(
  isIndeedMoreInterestingThan(5, 3),
  proof(
    goal(isIndeedMoreInterestingThan(5, 3)),
    by(rule("backward.pl", clause(2))),
    uses([
      proof(
        goal(moreInterestingThan(5, 3)),
        by(rule("backward.pl", clause(1))),
        bindings([binding("X", 5), binding("Y", 3)]),
        uses([
          proof(
            goal(>(5, 3)),
            by(builtin(>, 2))
          )
        ])
      )
    ])
  )
).

