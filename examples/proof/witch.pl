witch(girl).
why(
  witch(girl),
  proof(
    goal(witch(girl)),
    by(rule("witch.pl", clause(6))),
    bindings([binding("X", girl)]),
    uses([
      proof(
        goal(burns(girl)),
        by(rule("witch.pl", clause(8))),
        bindings([binding("X", girl)]),
        uses([
          proof(
            goal(madeOfWood(girl)),
            by(rule("witch.pl", clause(9))),
            bindings([binding("X", girl)]),
            uses([
              proof(
                goal(floats(girl)),
                by(rule("witch.pl", clause(11))),
                bindings([binding("Y", girl), binding("X", duck)]),
                uses([
                  proof(
                    goal(sameWeight(duck, girl)),
                    by(fact("witch.pl", clause(12)))
                  ),
                  proof(
                    goal(floats(duck)),
                    by(fact("witch.pl", clause(10)))
                  )
                ])
              )
            ])
          )
        ])
      ),
      proof(
        goal(woman(girl)),
        by(fact("witch.pl", clause(7)))
      )
    ])
  )
).

burns(duck).
why(
  burns(duck),
  proof(
    goal(burns(duck)),
    by(rule("witch.pl", clause(8))),
    bindings([binding("X", duck)]),
    uses([
      proof(
        goal(madeOfWood(duck)),
        by(rule("witch.pl", clause(9))),
        bindings([binding("X", duck)]),
        uses([
          proof(
            goal(floats(duck)),
            by(fact("witch.pl", clause(10)))
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
    by(rule("witch.pl", clause(8))),
    bindings([binding("X", girl)]),
    uses([
      proof(
        goal(madeOfWood(girl)),
        by(rule("witch.pl", clause(9))),
        bindings([binding("X", girl)]),
        uses([
          proof(
            goal(floats(girl)),
            by(rule("witch.pl", clause(11))),
            bindings([binding("Y", girl), binding("X", duck)]),
            uses([
              proof(
                goal(sameWeight(duck, girl)),
                by(fact("witch.pl", clause(12)))
              ),
              proof(
                goal(floats(duck)),
                by(fact("witch.pl", clause(10)))
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
    by(rule("witch.pl", clause(9))),
    bindings([binding("X", duck)]),
    uses([
      proof(
        goal(floats(duck)),
        by(fact("witch.pl", clause(10)))
      )
    ])
  )
).

madeOfWood(girl).
why(
  madeOfWood(girl),
  proof(
    goal(madeOfWood(girl)),
    by(rule("witch.pl", clause(9))),
    bindings([binding("X", girl)]),
    uses([
      proof(
        goal(floats(girl)),
        by(rule("witch.pl", clause(11))),
        bindings([binding("Y", girl), binding("X", duck)]),
        uses([
          proof(
            goal(sameWeight(duck, girl)),
            by(fact("witch.pl", clause(12)))
          ),
          proof(
            goal(floats(duck)),
            by(fact("witch.pl", clause(10)))
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
    by(rule("witch.pl", clause(11))),
    bindings([binding("Y", girl), binding("X", duck)]),
    uses([
      proof(
        goal(sameWeight(duck, girl)),
        by(fact("witch.pl", clause(12)))
      ),
      proof(
        goal(floats(duck)),
        by(fact("witch.pl", clause(10)))
      )
    ])
  )
).

holds_result(witchExample, true).
why(
  holds_result(witchExample, true),
  proof(
    goal(holds_result(witchExample, true)),
    by(rule("witch.pl", clause(13))),
    uses([
      proof(
        goal(witch(girl)),
        by(rule("witch.pl", clause(6))),
        bindings([binding("X", girl)]),
        uses([
          proof(
            goal(burns(girl)),
            by(rule("witch.pl", clause(8))),
            bindings([binding("X", girl)]),
            uses([
              proof(
                goal(madeOfWood(girl)),
                by(rule("witch.pl", clause(9))),
                bindings([binding("X", girl)]),
                uses([
                  proof(
                    goal(floats(girl)),
                    by(rule("witch.pl", clause(11))),
                    bindings([binding("Y", girl), binding("X", duck)]),
                    uses([
                      proof(
                        goal(sameWeight(duck, girl)),
                        by(fact("witch.pl", clause(12)))
                      ),
                      proof(
                        goal(floats(duck)),
                        by(fact("witch.pl", clause(10)))
                      )
                    ])
                  )
                ])
              )
            ])
          ),
          proof(
            goal(woman(girl)),
            by(fact("witch.pl", clause(7)))
          )
        ])
      )
    ])
  )
).

