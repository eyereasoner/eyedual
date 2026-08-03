holdsFor(diamondProperty, r).
why(
  holdsFor(diamondProperty, r),
  proof(
    goal(holdsFor(diamondProperty, r)),
    by(rule("diamond-property.pl", clause(14))),
    bindings([binding("Rel", r)]),
    uses([
      proof(
        goal(diamond(r, a, b, c, d)),
        by(rule("diamond-property.pl", clause(11))),
        bindings([binding("Rel", r), binding("A", a), binding("B", b), binding("C", c), binding("D", d)]),
        uses([
          proof(
            goal(step(r, a, b)),
            by(rule("diamond-property.pl", clause(12))),
            bindings([binding("X", a), binding("Y", b)]),
            uses([
              proof(
                goal(r(a, b)),
                by(fact("diamond-property.pl", clause(5)))
              )
            ])
          ),
          proof(
            goal(step(r, a, c)),
            by(rule("diamond-property.pl", clause(12))),
            bindings([binding("X", a), binding("Y", c)]),
            uses([
              proof(
                goal(r(a, c)),
                by(fact("diamond-property.pl", clause(6)))
              )
            ])
          ),
          proof(
            goal(step(r, b, d)),
            by(rule("diamond-property.pl", clause(12))),
            bindings([binding("X", b), binding("Y", d)]),
            uses([
              proof(
                goal(r(b, d)),
                by(fact("diamond-property.pl", clause(7)))
              )
            ])
          ),
          proof(
            goal(step(r, c, d)),
            by(rule("diamond-property.pl", clause(12))),
            bindings([binding("X", c), binding("Y", d)]),
            uses([
              proof(
                goal(r(c, d)),
                by(fact("diamond-property.pl", clause(8)))
              )
            ])
          )
        ])
      )
    ])
  )
).

holdsFor(diamondProperty, re).
why(
  holdsFor(diamondProperty, re),
  proof(
    goal(holdsFor(diamondProperty, re)),
    by(rule("diamond-property.pl", clause(14))),
    bindings([binding("Rel", re)]),
    uses([
      proof(
        goal(diamond(re, a, b, c, d)),
        by(rule("diamond-property.pl", clause(11))),
        bindings([binding("Rel", re), binding("A", a), binding("B", b), binding("C", c), binding("D", d)]),
        uses([
          proof(
            goal(step(re, a, b)),
            by(rule("diamond-property.pl", clause(13))),
            bindings([binding("X", a), binding("Y", b)]),
            uses([
              proof(
                goal(re(a, b)),
                by(rule("diamond-property.pl", clause(10))),
                bindings([binding("X", a), binding("Y", b)]),
                uses([
                  proof(
                    goal(r(a, b)),
                    by(fact("diamond-property.pl", clause(5)))
                  )
                ])
              )
            ])
          ),
          proof(
            goal(step(re, a, c)),
            by(rule("diamond-property.pl", clause(13))),
            bindings([binding("X", a), binding("Y", c)]),
            uses([
              proof(
                goal(re(a, c)),
                by(rule("diamond-property.pl", clause(10))),
                bindings([binding("X", a), binding("Y", c)]),
                uses([
                  proof(
                    goal(r(a, c)),
                    by(fact("diamond-property.pl", clause(6)))
                  )
                ])
              )
            ])
          ),
          proof(
            goal(step(re, b, d)),
            by(rule("diamond-property.pl", clause(13))),
            bindings([binding("X", b), binding("Y", d)]),
            uses([
              proof(
                goal(re(b, d)),
                by(rule("diamond-property.pl", clause(10))),
                bindings([binding("X", b), binding("Y", d)]),
                uses([
                  proof(
                    goal(r(b, d)),
                    by(fact("diamond-property.pl", clause(7)))
                  )
                ])
              )
            ])
          ),
          proof(
            goal(step(re, c, d)),
            by(rule("diamond-property.pl", clause(13))),
            bindings([binding("X", c), binding("Y", d)]),
            uses([
              proof(
                goal(re(c, d)),
                by(rule("diamond-property.pl", clause(10))),
                bindings([binding("X", c), binding("Y", d)]),
                uses([
                  proof(
                    goal(r(c, d)),
                    by(fact("diamond-property.pl", clause(8)))
                  )
                ])
              )
            ])
          )
        ])
      )
    ])
  )
).

commonSuccessor(diamondProperty, d).
why(
  commonSuccessor(diamondProperty, d),
  proof(
    goal(commonSuccessor(diamondProperty, d)),
    by(rule("diamond-property.pl", clause(15))),
    bindings([binding("D", d)]),
    uses([
      proof(
        goal(diamond(r, a, b, c, d)),
        by(rule("diamond-property.pl", clause(11))),
        bindings([binding("Rel", r), binding("A", a), binding("B", b), binding("C", c), binding("D", d)]),
        uses([
          proof(
            goal(step(r, a, b)),
            by(rule("diamond-property.pl", clause(12))),
            bindings([binding("X", a), binding("Y", b)]),
            uses([
              proof(
                goal(r(a, b)),
                by(fact("diamond-property.pl", clause(5)))
              )
            ])
          ),
          proof(
            goal(step(r, a, c)),
            by(rule("diamond-property.pl", clause(12))),
            bindings([binding("X", a), binding("Y", c)]),
            uses([
              proof(
                goal(r(a, c)),
                by(fact("diamond-property.pl", clause(6)))
              )
            ])
          ),
          proof(
            goal(step(r, b, d)),
            by(rule("diamond-property.pl", clause(12))),
            bindings([binding("X", b), binding("Y", d)]),
            uses([
              proof(
                goal(r(b, d)),
                by(fact("diamond-property.pl", clause(7)))
              )
            ])
          ),
          proof(
            goal(step(r, c, d)),
            by(rule("diamond-property.pl", clause(12))),
            bindings([binding("X", c), binding("Y", d)]),
            uses([
              proof(
                goal(r(c, d)),
                by(fact("diamond-property.pl", clause(8)))
              )
            ])
          )
        ])
      )
    ])
  )
).

preservedUnderReflexiveClosure(diamondProperty, true).
why(
  preservedUnderReflexiveClosure(diamondProperty, true),
  proof(
    goal(preservedUnderReflexiveClosure(diamondProperty, true)),
    by(rule("diamond-property.pl", clause(16))),
    uses([
      proof(
        goal(diamond(re, a, b, c, d)),
        by(rule("diamond-property.pl", clause(11))),
        bindings([binding("Rel", re), binding("A", a), binding("B", b), binding("C", c), binding("D", d)]),
        uses([
          proof(
            goal(step(re, a, b)),
            by(rule("diamond-property.pl", clause(13))),
            bindings([binding("X", a), binding("Y", b)]),
            uses([
              proof(
                goal(re(a, b)),
                by(rule("diamond-property.pl", clause(10))),
                bindings([binding("X", a), binding("Y", b)]),
                uses([
                  proof(
                    goal(r(a, b)),
                    by(fact("diamond-property.pl", clause(5)))
                  )
                ])
              )
            ])
          ),
          proof(
            goal(step(re, a, c)),
            by(rule("diamond-property.pl", clause(13))),
            bindings([binding("X", a), binding("Y", c)]),
            uses([
              proof(
                goal(re(a, c)),
                by(rule("diamond-property.pl", clause(10))),
                bindings([binding("X", a), binding("Y", c)]),
                uses([
                  proof(
                    goal(r(a, c)),
                    by(fact("diamond-property.pl", clause(6)))
                  )
                ])
              )
            ])
          ),
          proof(
            goal(step(re, b, d)),
            by(rule("diamond-property.pl", clause(13))),
            bindings([binding("X", b), binding("Y", d)]),
            uses([
              proof(
                goal(re(b, d)),
                by(rule("diamond-property.pl", clause(10))),
                bindings([binding("X", b), binding("Y", d)]),
                uses([
                  proof(
                    goal(r(b, d)),
                    by(fact("diamond-property.pl", clause(7)))
                  )
                ])
              )
            ])
          ),
          proof(
            goal(step(re, c, d)),
            by(rule("diamond-property.pl", clause(13))),
            bindings([binding("X", c), binding("Y", d)]),
            uses([
              proof(
                goal(re(c, d)),
                by(rule("diamond-property.pl", clause(10))),
                bindings([binding("X", c), binding("Y", d)]),
                uses([
                  proof(
                    goal(r(c, d)),
                    by(fact("diamond-property.pl", clause(8)))
                  )
                ])
              )
            ])
          )
        ])
      )
    ])
  )
).

