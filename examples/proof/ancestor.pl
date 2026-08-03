ancestor(pat, jan).
why(
  ancestor(pat, jan),
  proof(
    goal(ancestor(pat, jan)),
    by(rule("ancestor.pl", clause(4))),
    bindings([binding("X", pat), binding("Y", jan)]),
    uses([
      proof(
        goal(parent(pat, jan)),
        by(fact("ancestor.pl", clause(1)))
      )
    ])
  )
).

ancestor(jan, lies).
why(
  ancestor(jan, lies),
  proof(
    goal(ancestor(jan, lies)),
    by(rule("ancestor.pl", clause(4))),
    bindings([binding("X", jan), binding("Y", lies)]),
    uses([
      proof(
        goal(parent(jan, lies)),
        by(fact("ancestor.pl", clause(2)))
      )
    ])
  )
).

ancestor(lies, emma).
why(
  ancestor(lies, emma),
  proof(
    goal(ancestor(lies, emma)),
    by(rule("ancestor.pl", clause(4))),
    bindings([binding("X", lies), binding("Y", emma)]),
    uses([
      proof(
        goal(parent(lies, emma)),
        by(fact("ancestor.pl", clause(3)))
      )
    ])
  )
).

ancestor(pat, lies).
why(
  ancestor(pat, lies),
  proof(
    goal(ancestor(pat, lies)),
    by(rule("ancestor.pl", clause(5))),
    bindings([binding("X", pat), binding("Z", lies), binding("Y", jan)]),
    uses([
      proof(
        goal(parent(pat, jan)),
        by(fact("ancestor.pl", clause(1)))
      ),
      proof(
        goal(ancestor(jan, lies)),
        by(rule("ancestor.pl", clause(4))),
        bindings([binding("X", jan), binding("Y", lies)]),
        uses([
          proof(
            goal(parent(jan, lies)),
            by(fact("ancestor.pl", clause(2)))
          )
        ])
      )
    ])
  )
).

ancestor(pat, emma).
why(
  ancestor(pat, emma),
  proof(
    goal(ancestor(pat, emma)),
    by(rule("ancestor.pl", clause(5))),
    bindings([binding("X", pat), binding("Z", emma), binding("Y", jan)]),
    uses([
      proof(
        goal(parent(pat, jan)),
        by(fact("ancestor.pl", clause(1)))
      ),
      proof(
        goal(ancestor(jan, emma)),
        by(rule("ancestor.pl", clause(5))),
        bindings([binding("X", jan), binding("Z", emma), binding("Y", lies)]),
        uses([
          proof(
            goal(parent(jan, lies)),
            by(fact("ancestor.pl", clause(2)))
          ),
          proof(
            goal(ancestor(lies, emma)),
            by(rule("ancestor.pl", clause(4))),
            bindings([binding("X", lies), binding("Y", emma)]),
            uses([
              proof(
                goal(parent(lies, emma)),
                by(fact("ancestor.pl", clause(3)))
              )
            ])
          )
        ])
      )
    ])
  )
).

ancestor(jan, emma).
why(
  ancestor(jan, emma),
  proof(
    goal(ancestor(jan, emma)),
    by(rule("ancestor.pl", clause(5))),
    bindings([binding("X", jan), binding("Z", emma), binding("Y", lies)]),
    uses([
      proof(
        goal(parent(jan, lies)),
        by(fact("ancestor.pl", clause(2)))
      ),
      proof(
        goal(ancestor(lies, emma)),
        by(rule("ancestor.pl", clause(4))),
        bindings([binding("X", lies), binding("Y", emma)]),
        uses([
          proof(
            goal(parent(lies, emma)),
            by(fact("ancestor.pl", clause(3)))
          )
        ])
      )
    ])
  )
).

