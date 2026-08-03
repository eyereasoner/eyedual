defaultSupports(nixon, pacifist).
why(
  defaultSupports(nixon, pacifist),
  proof(
    goal(defaultSupports(nixon, pacifist)),
    by(rule("nixon-diamond.pl", clause(8))),
    bindings([binding("Person", nixon), binding("Conclusion", pacifist)]),
    uses([
      proof(
        goal(supports_default(nixon, pacifist)),
        by(rule("nixon-diamond.pl", clause(3))),
        bindings([binding("Person", nixon)]),
        uses([
          proof(
            goal(kind(nixon, quaker)),
            by(fact("nixon-diamond.pl", clause(1)))
          )
        ])
      )
    ])
  )
).

defaultSupports(nixon, hawk).
why(
  defaultSupports(nixon, hawk),
  proof(
    goal(defaultSupports(nixon, hawk)),
    by(rule("nixon-diamond.pl", clause(8))),
    bindings([binding("Person", nixon), binding("Conclusion", hawk)]),
    uses([
      proof(
        goal(supports_default(nixon, hawk)),
        by(rule("nixon-diamond.pl", clause(4))),
        bindings([binding("Person", nixon)]),
        uses([
          proof(
            goal(kind(nixon, republican)),
            by(fact("nixon-diamond.pl", clause(2)))
          )
        ])
      )
    ])
  )
).

conflict(nixon, conflict(pacifist, hawk)).
why(
  conflict(nixon, conflict(pacifist, hawk)),
  proof(
    goal(conflict(nixon, conflict(pacifist, hawk))),
    by(rule("nixon-diamond.pl", clause(9))),
    bindings([binding("Person", nixon), binding("A", pacifist), binding("B", hawk)]),
    uses([
      proof(
        goal(conflicted(nixon, pacifist, hawk)),
        by(rule("nixon-diamond.pl", clause(7))),
        bindings([binding("Person", nixon), binding("A", pacifist), binding("B", hawk)]),
        uses([
          proof(
            goal(supports_default(nixon, pacifist)),
            by(rule("nixon-diamond.pl", clause(3))),
            bindings([binding("Person", nixon)]),
            uses([
              proof(
                goal(kind(nixon, quaker)),
                by(fact("nixon-diamond.pl", clause(1)))
              )
            ])
          ),
          proof(
            goal(supports_default(nixon, hawk)),
            by(rule("nixon-diamond.pl", clause(4))),
            bindings([binding("Person", nixon)]),
            uses([
              proof(
                goal(kind(nixon, republican)),
                by(fact("nixon-diamond.pl", clause(2)))
              )
            ])
          ),
          proof(
            goal(contrary(pacifist, hawk)),
            by(fact("nixon-diamond.pl", clause(5)))
          )
        ])
      )
    ])
  )
).

conflict(nixon, conflict(hawk, pacifist)).
why(
  conflict(nixon, conflict(hawk, pacifist)),
  proof(
    goal(conflict(nixon, conflict(hawk, pacifist))),
    by(rule("nixon-diamond.pl", clause(9))),
    bindings([binding("Person", nixon), binding("A", hawk), binding("B", pacifist)]),
    uses([
      proof(
        goal(conflicted(nixon, hawk, pacifist)),
        by(rule("nixon-diamond.pl", clause(7))),
        bindings([binding("Person", nixon), binding("A", hawk), binding("B", pacifist)]),
        uses([
          proof(
            goal(supports_default(nixon, hawk)),
            by(rule("nixon-diamond.pl", clause(4))),
            bindings([binding("Person", nixon)]),
            uses([
              proof(
                goal(kind(nixon, republican)),
                by(fact("nixon-diamond.pl", clause(2)))
              )
            ])
          ),
          proof(
            goal(supports_default(nixon, pacifist)),
            by(rule("nixon-diamond.pl", clause(3))),
            bindings([binding("Person", nixon)]),
            uses([
              proof(
                goal(kind(nixon, quaker)),
                by(fact("nixon-diamond.pl", clause(1)))
              )
            ])
          ),
          proof(
            goal(contrary(hawk, pacifist)),
            by(fact("nixon-diamond.pl", clause(6)))
          )
        ])
      )
    ])
  )
).

status(nixon, conflicted_default_case).
why(
  status(nixon, conflicted_default_case),
  proof(
    goal(status(nixon, conflicted_default_case)),
    by(rule("nixon-diamond.pl", clause(10))),
    bindings([binding("Person", nixon), binding("_a", pacifist), binding("_b", hawk)]),
    uses([
      proof(
        goal(conflicted(nixon, pacifist, hawk)),
        by(rule("nixon-diamond.pl", clause(7))),
        bindings([binding("Person", nixon), binding("A", pacifist), binding("B", hawk)]),
        uses([
          proof(
            goal(supports_default(nixon, pacifist)),
            by(rule("nixon-diamond.pl", clause(3))),
            bindings([binding("Person", nixon)]),
            uses([
              proof(
                goal(kind(nixon, quaker)),
                by(fact("nixon-diamond.pl", clause(1)))
              )
            ])
          ),
          proof(
            goal(supports_default(nixon, hawk)),
            by(rule("nixon-diamond.pl", clause(4))),
            bindings([binding("Person", nixon)]),
            uses([
              proof(
                goal(kind(nixon, republican)),
                by(fact("nixon-diamond.pl", clause(2)))
              )
            ])
          ),
          proof(
            goal(contrary(pacifist, hawk)),
            by(fact("nixon-diamond.pl", clause(5)))
          )
        ])
      )
    ])
  )
).

