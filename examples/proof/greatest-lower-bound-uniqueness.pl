sameGreatestLowerBound(a, b, g1, g2).
why(
  sameGreatestLowerBound(a, b, g1, g2),
  proof(
    goal(sameGreatestLowerBound(a, b, g1, g2)),
    by(rule("greatest-lower-bound-uniqueness.pl", clause(6))),
    bindings([binding("A", a), binding("B", b), binding("M", g1), binding("N", g2)]),
    uses([
      proof(
        goal(glbOf(g1, a, b)),
        by(fact("greatest-lower-bound-uniqueness.pl", clause(1)))
      ),
      proof(
        goal(glbOf(g2, a, b)),
        by(fact("greatest-lower-bound-uniqueness.pl", clause(2)))
      ),
      proof(
        goal(sameTerm(g1, g2)),
        by(rule("greatest-lower-bound-uniqueness.pl", clause(5))),
        bindings([binding("M", g1), binding("N", g2)]),
        uses([
          proof(
            goal(leq(g1, g2)),
            by(rule("greatest-lower-bound-uniqueness.pl", clause(4))),
            bindings([binding("L", g1), binding("M", g2), binding("A", a), binding("B", b)]),
            uses([
              proof(
                goal(glbOf(g2, a, b)),
                by(fact("greatest-lower-bound-uniqueness.pl", clause(2)))
              ),
              proof(
                goal(lowerBoundOf(g1, a, b)),
                by(rule("greatest-lower-bound-uniqueness.pl", clause(3))),
                bindings([binding("M", g1), binding("A", a), binding("B", b)]),
                uses([
                  proof(
                    goal(glbOf(g1, a, b)),
                    by(fact("greatest-lower-bound-uniqueness.pl", clause(1)))
                  )
                ])
              )
            ])
          ),
          proof(
            goal(leq(g2, g1)),
            by(rule("greatest-lower-bound-uniqueness.pl", clause(4))),
            bindings([binding("L", g2), binding("M", g1), binding("A", a), binding("B", b)]),
            uses([
              proof(
                goal(glbOf(g1, a, b)),
                by(fact("greatest-lower-bound-uniqueness.pl", clause(1)))
              ),
              proof(
                goal(lowerBoundOf(g2, a, b)),
                by(rule("greatest-lower-bound-uniqueness.pl", clause(3))),
                bindings([binding("M", g2), binding("A", a), binding("B", b)]),
                uses([
                  proof(
                    goal(glbOf(g2, a, b)),
                    by(fact("greatest-lower-bound-uniqueness.pl", clause(2)))
                  )
                ])
              )
            ])
          )
        ])
      ),
      proof(
        goal(\=(g1, g2)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameGreatestLowerBound(a, b, g2, g1).
why(
  sameGreatestLowerBound(a, b, g2, g1),
  proof(
    goal(sameGreatestLowerBound(a, b, g2, g1)),
    by(rule("greatest-lower-bound-uniqueness.pl", clause(6))),
    bindings([binding("A", a), binding("B", b), binding("M", g2), binding("N", g1)]),
    uses([
      proof(
        goal(glbOf(g2, a, b)),
        by(fact("greatest-lower-bound-uniqueness.pl", clause(2)))
      ),
      proof(
        goal(glbOf(g1, a, b)),
        by(fact("greatest-lower-bound-uniqueness.pl", clause(1)))
      ),
      proof(
        goal(sameTerm(g2, g1)),
        by(rule("greatest-lower-bound-uniqueness.pl", clause(5))),
        bindings([binding("M", g2), binding("N", g1)]),
        uses([
          proof(
            goal(leq(g2, g1)),
            by(rule("greatest-lower-bound-uniqueness.pl", clause(4))),
            bindings([binding("L", g2), binding("M", g1), binding("A", a), binding("B", b)]),
            uses([
              proof(
                goal(glbOf(g1, a, b)),
                by(fact("greatest-lower-bound-uniqueness.pl", clause(1)))
              ),
              proof(
                goal(lowerBoundOf(g2, a, b)),
                by(rule("greatest-lower-bound-uniqueness.pl", clause(3))),
                bindings([binding("M", g2), binding("A", a), binding("B", b)]),
                uses([
                  proof(
                    goal(glbOf(g2, a, b)),
                    by(fact("greatest-lower-bound-uniqueness.pl", clause(2)))
                  )
                ])
              )
            ])
          ),
          proof(
            goal(leq(g1, g2)),
            by(rule("greatest-lower-bound-uniqueness.pl", clause(4))),
            bindings([binding("L", g1), binding("M", g2), binding("A", a), binding("B", b)]),
            uses([
              proof(
                goal(glbOf(g2, a, b)),
                by(fact("greatest-lower-bound-uniqueness.pl", clause(2)))
              ),
              proof(
                goal(lowerBoundOf(g1, a, b)),
                by(rule("greatest-lower-bound-uniqueness.pl", clause(3))),
                bindings([binding("M", g1), binding("A", a), binding("B", b)]),
                uses([
                  proof(
                    goal(glbOf(g1, a, b)),
                    by(fact("greatest-lower-bound-uniqueness.pl", clause(1)))
                  )
                ])
              )
            ])
          )
        ])
      ),
      proof(
        goal(\=(g2, g1)),
        by(builtin(\=, 2))
      )
    ])
  )
).

