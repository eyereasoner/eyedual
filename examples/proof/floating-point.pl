value(sum, 3.75).
why(
  value(sum, 3.75),
  proof(
    goal(value(sum, 3.75)),
    by(rule("floating-point.pl", clause(3))),
    bindings([binding("X", 3.75)]),
    uses([
      proof(
        goal(is(3.75, '+'(1.5, 2.25))),
        by(builtin(is, 2))
      )
    ])
  )
).

value(difference, 6.875).
why(
  value(difference, 6.875),
  proof(
    goal(value(difference, 6.875)),
    by(rule("floating-point.pl", clause(4))),
    bindings([binding("X", 6.875)]),
    uses([
      proof(
        goal(is(6.875, '-'(10.0, 3.125))),
        by(builtin(is, 2))
      )
    ])
  )
).

value(product, 10.0).
why(
  value(product, 10.0),
  proof(
    goal(value(product, 10.0)),
    by(rule("floating-point.pl", clause(5))),
    bindings([binding("X", 10.0)]),
    uses([
      proof(
        goal(is(10.0, *(2.5, 4.0))),
        by(builtin(is, 2))
      )
    ])
  )
).

value(quotient, 3.75).
why(
  value(quotient, 3.75),
  proof(
    goal(value(quotient, 3.75)),
    by(rule("floating-point.pl", clause(6))),
    bindings([binding("X", 3.75)]),
    uses([
      proof(
        goal(is(3.75, /(7.5, 2))),
        by(builtin(is, 2))
      )
    ])
  )
).

value(sqrtByPower, 3.0).
why(
  value(sqrtByPower, 3.0),
  proof(
    goal(value(sqrtByPower, 3.0)),
    by(rule("floating-point.pl", clause(7))),
    bindings([binding("X", 3.0)]),
    uses([
      proof(
        goal(is(3.0, **(9.0, 0.5))),
        by(builtin(is, 2))
      )
    ])
  )
).

value(mathSum, 1.0).
why(
  value(mathSum, 1.0),
  proof(
    goal(value(mathSum, 1.0)),
    by(rule("floating-point.pl", clause(8))),
    bindings([binding("X", 1.0)]),
    uses([
      proof(
        goal(is(1.0, '+'(0.125, 0.875))),
        by(builtin(is, 2))
      )
    ])
  )
).

value(mathProduct, 3.0).
why(
  value(mathProduct, 3.0),
  proof(
    goal(value(mathProduct, 3.0)),
    by(rule("floating-point.pl", clause(9))),
    bindings([binding("X", 3.0)]),
    uses([
      proof(
        goal(is(3.0, *(6.0, 0.5))),
        by(builtin(is, 2))
      )
    ])
  )
).

value(comfortable, true).
why(
  value(comfortable, true),
  proof(
    goal(value(comfortable, true)),
    by(rule("floating-point.pl", clause(11))),
    bindings([binding("R", 21.5)]),
    uses([
      proof(
        goal(sample(roomC, 21.5)),
        by(fact("floating-point.pl", clause(1)))
      ),
      proof(
        goal(>=(21.5, 21.0)),
        by(builtin(>=, 2))
      ),
      proof(
        goal(=<(21.5, 22.0)),
        by(builtin(=<, 2))
      )
    ])
  )
).

than(warmer, targetC).
why(
  than(warmer, targetC),
  proof(
    goal(than(warmer, targetC)),
    by(rule("floating-point.pl", clause(10))),
    bindings([binding("R", 21.5), binding("T", 19.25)]),
    uses([
      proof(
        goal(sample(roomC, 21.5)),
        by(fact("floating-point.pl", clause(1)))
      ),
      proof(
        goal(sample(targetC, 19.25)),
        by(fact("floating-point.pl", clause(2)))
      ),
      proof(
        goal(>(21.5, 19.25)),
        by(builtin(>, 2))
      )
    ])
  )
).

