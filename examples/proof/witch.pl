witch(girl).
why(
  witch(girl),
  proof(
    goal(witch(girl)),
    by(rule("witch.pl", clause(1))),
    bindings([binding("X", girl)]),
    uses([
      proof(
        goal(burns(girl)),
        by(rule("witch.pl", clause(3))),
        bindings([binding("X", girl)]),
        uses([
          proof(
            goal(madeOfWood(girl)),
            by(rule("witch.pl", clause(4))),
            bindings([binding("X", girl)]),
            uses([
              proof(
                goal(floats(girl)),
                by(rule("witch.pl", clause(6))),
                bindings([binding("Y", girl), binding("X", duck)]),
                uses([
                  proof(
                    goal(sameWeight(duck, girl)),
                    by(fact("witch.pl", clause(7)))
                  ),
                  proof(
                    goal(floats(duck)),
                    by(fact("witch.pl", clause(5)))
                  )
                ])
              )
            ])
          )
        ])
      ),
      proof(
        goal(woman(girl)),
        by(fact("witch.pl", clause(2)))
      )
    ])
  )
).

burns(duck).
why(
  burns(duck),
  proof(
    goal(burns(duck)),
    by(rule("witch.pl", clause(3))),
    bindings([binding("X", duck)]),
    uses([
      proof(
        goal(madeOfWood(duck)),
        by(rule("witch.pl", clause(4))),
        bindings([binding("X", duck)]),
        uses([
          proof(
            goal(floats(duck)),
            by(fact("witch.pl", clause(5)))
          )
        ])
      )
    ])
  )
).

burns(girl).
why(
  burns(girl),
  proof(
    goal(burns(girl)),
    by(rule("witch.pl", clause(3))),
    bindings([binding("X", girl)]),
    uses([
      proof(
        goal(madeOfWood(girl)),
        by(rule("witch.pl", clause(4))),
        bindings([binding("X", girl)]),
        uses([
          proof(
            goal(floats(girl)),
            by(rule("witch.pl", clause(6))),
            bindings([binding("Y", girl), binding("X", duck)]),
            uses([
              proof(
                goal(sameWeight(duck, girl)),
                by(fact("witch.pl", clause(7)))
              ),
              proof(
                goal(floats(duck)),
                by(fact("witch.pl", clause(5)))
              )
            ])
          )
        ])
      )
    ])
  )
).

madeOfWood(duck).
why(
  madeOfWood(duck),
  proof(
    goal(madeOfWood(duck)),
    by(rule("witch.pl", clause(4))),
    bindings([binding("X", duck)]),
    uses([
      proof(
        goal(floats(duck)),
        by(fact("witch.pl", clause(5)))
      )
    ])
  )
).

madeOfWood(girl).
why(
  madeOfWood(girl),
  proof(
    goal(madeOfWood(girl)),
    by(rule("witch.pl", clause(4))),
    bindings([binding("X", girl)]),
    uses([
      proof(
        goal(floats(girl)),
        by(rule("witch.pl", clause(6))),
        bindings([binding("Y", girl), binding("X", duck)]),
        uses([
          proof(
            goal(sameWeight(duck, girl)),
            by(fact("witch.pl", clause(7)))
          ),
          proof(
            goal(floats(duck)),
            by(fact("witch.pl", clause(5)))
          )
        ])
      )
    ])
  )
).

floats(girl).
why(
  floats(girl),
  proof(
    goal(floats(girl)),
    by(rule("witch.pl", clause(6))),
    bindings([binding("Y", girl), binding("X", duck)]),
    uses([
      proof(
        goal(sameWeight(duck, girl)),
        by(fact("witch.pl", clause(7)))
      ),
      proof(
        goal(floats(duck)),
        by(fact("witch.pl", clause(5)))
      )
    ])
  )
).

holds_result(witchExample, true).
why(
  holds_result(witchExample, true),
  proof(
    goal(holds_result(witchExample, true)),
    by(rule("witch.pl", clause(8))),
    uses([
      proof(
        goal(witch(girl)),
        by(rule("witch.pl", clause(1))),
        bindings([binding("X", girl)]),
        uses([
          proof(
            goal(burns(girl)),
            by(rule("witch.pl", clause(3))),
            bindings([binding("X", girl)]),
            uses([
              proof(
                goal(madeOfWood(girl)),
                by(rule("witch.pl", clause(4))),
                bindings([binding("X", girl)]),
                uses([
                  proof(
                    goal(floats(girl)),
                    by(rule("witch.pl", clause(6))),
                    bindings([binding("Y", girl), binding("X", duck)]),
                    uses([
                      proof(
                        goal(sameWeight(duck, girl)),
                        by(fact("witch.pl", clause(7)))
                      ),
                      proof(
                        goal(floats(duck)),
                        by(fact("witch.pl", clause(5)))
                      )
                    ])
                  )
                ])
              )
            ])
          ),
          proof(
            goal(woman(girl)),
            by(fact("witch.pl", clause(2)))
          )
        ])
      )
    ])
  )
).

