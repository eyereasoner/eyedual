type(sk_0, cat).
why(
  type(sk_0, cat),
  proof(
    goal(type(sk_0, cat)),
    by(rule("cat-koko.pl", clause(4))),
    bindings([binding("X", sk_0)]),
    uses([
      proof(
        goal(animal(koko)),
        by(fact("cat-koko.pl", clause(1)))
      ),
      proof(
        goal(witness(cat, sk_0)),
        by(fact("cat-koko.pl", clause(2)))
      )
    ])
  )
).

type(sk_1, british_short_hair).
why(
  type(sk_1, british_short_hair),
  proof(
    goal(type(sk_1, british_short_hair)),
    by(rule("cat-koko.pl", clause(5))),
    bindings([binding("X", sk_1)]),
    uses([
      proof(
        goal(animal(koko)),
        by(fact("cat-koko.pl", clause(1)))
      ),
      proof(
        goal(witness(british_short_hair, sk_1)),
        by(fact("cat-koko.pl", clause(3)))
      )
    ])
  )
).

holds_result(test, true).
why(
  holds_result(test, true),
  proof(
    goal(holds_result(test, true)),
    by(rule("cat-koko.pl", clause(6))),
    bindings([binding("X", sk_0), binding("Y", sk_1)]),
    uses([
      proof(
        goal(type(sk_0, cat)),
        by(rule("cat-koko.pl", clause(4))),
        bindings([binding("X", sk_0)]),
        uses([
          proof(
            goal(animal(koko)),
            by(fact("cat-koko.pl", clause(1)))
          ),
          proof(
            goal(witness(cat, sk_0)),
            by(fact("cat-koko.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(type(sk_1, british_short_hair)),
        by(rule("cat-koko.pl", clause(5))),
        bindings([binding("X", sk_1)]),
        uses([
          proof(
            goal(animal(koko)),
            by(fact("cat-koko.pl", clause(1)))
          ),
          proof(
            goal(witness(british_short_hair, sk_1)),
            by(fact("cat-koko.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(\=(sk_0, sk_1)),
        by(builtin(\=, 2))
      )
    ])
  )
).

