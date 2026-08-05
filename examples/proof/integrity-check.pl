invalid_state(stone, conflicting_colors).
why(
  invalid_state(stone, conflicting_colors),
  proof(
    goal(invalid_state(stone, conflicting_colors)),
    by(rule("integrity-check.pl", clause(3))),
    bindings([binding("X", stone)]),
    uses([
      proof(
        goal(color(stone, black)),
        by(fact("integrity-check.pl", clause(1)))
      ),
      proof(
        goal(color(stone, white)),
        by(fact("integrity-check.pl", clause(2)))
      )
    ])
  )
).

status(stone, invalid(conflicting_colors)).
why(
  status(stone, invalid(conflicting_colors)),
  proof(
    goal(status(stone, invalid(conflicting_colors))),
    by(rule("integrity-check.pl", clause(4))),
    bindings([binding("X", stone), binding("Reason", conflicting_colors)]),
    uses([
      proof(
        goal(invalid_state(stone, conflicting_colors)),
        by(rule("integrity-check.pl", clause(3))),
        bindings([binding("X", stone)]),
        uses([
          proof(
            goal(color(stone, black)),
            by(fact("integrity-check.pl", clause(1)))
          ),
          proof(
            goal(color(stone, white)),
            by(fact("integrity-check.pl", clause(2)))
          )
        ])
      )
    ])
  )
).

