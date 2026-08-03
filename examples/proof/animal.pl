type(joe, human).
why(
  type(joe, human),
  proof(
    goal(type(joe, human)),
    by(rule("animal.pl", clause(4))),
    uses([
      proof(
        goal(human(joe)),
        by(fact("animal.pl", clause(1)))
      )
    ])
  )
).

type(joe, animal).
why(
  type(joe, animal),
  proof(
    goal(type(joe, animal)),
    by(rule("animal.pl", clause(5))),
    uses([
      proof(
        goal(animal(joe)),
        by(rule("animal.pl", clause(3))),
        bindings([binding("X", joe)]),
        uses([
          proof(
            goal(human(joe)),
            by(fact("animal.pl", clause(1)))
          )
        ])
      )
    ])
  )
).

subclassOf(human, animal).
why(
  subclassOf(human, animal),
  proof(
    goal(subclassOf(human, animal)),
    by(rule("animal.pl", clause(6))),
    uses([
      proof(
        goal(animal(human)),
        by(fact("animal.pl", clause(2)))
      )
    ])
  )
).

succeeds(animalExample, true).
why(
  succeeds(animalExample, true),
  proof(
    goal(succeeds(animalExample, true)),
    by(rule("animal.pl", clause(7))),
    bindings([binding("__anon0", human)]),
    uses([
      proof(
        goal(animal(human)),
        by(fact("animal.pl", clause(2)))
      )
    ])
  )
).

