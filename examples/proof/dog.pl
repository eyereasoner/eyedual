mustHave(alice, dogLicense).
why(
  mustHave(alice, dogLicense),
  proof(
    goal(mustHave(alice, dogLicense)),
    by(rule("dog.pl", clause(9))),
    bindings([binding("Subject", alice), binding("Count", 5)]),
    uses([
      proof(
        goal(dogCount(alice, 5)),
        by(rule("dog.pl", clause(8))),
        bindings([binding("Subject", alice), binding("Count", 5), binding("_any", dog1)]),
        uses([
          proof(
            goal(hasDog(alice, dog1)),
            by(fact("dog.pl", clause(1)))
          ),
          proof(
            goal(countall(hasDog(alice, _dog), 5)),
            by(library(countall, 2))
          )
        ])
      ),
      proof(
        goal(>(5, 4)),
        by(builtin(>, 2))
      )
    ])
  )
).

