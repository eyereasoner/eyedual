result(root, 12).
why(
  result(root, 12),
  proof(
    goal(result(root, 12)),
    by(rule("expression-eval.pl", clause(13))),
    bindings([binding("Value", 12), binding("Node", eAdd)]),
    uses([
      proof(
        goal(root(eAdd)),
        by(fact("expression-eval.pl", clause(8)))
      ),
      proof(
        goal(value(eAdd, 12)),
        by(rule("expression-eval.pl", clause(10))),
        bindings([binding("Node", eAdd), binding("Value", 12), binding("Left", eMul), binding("Right", eSub), binding("Leftvalue", 6), binding("Rightvalue", 6)]),
        uses([
          proof(
            goal(expr(eAdd, add, eMul, eSub)),
            by(fact("expression-eval.pl", clause(7)))
          ),
          proof(
            goal(value(eMul, 6)),
            by(rule("expression-eval.pl", clause(12))),
            bindings([binding("Node", eMul), binding("Value", 6), binding("Left", n2), binding("Right", n3), binding("Leftvalue", 2), binding("Rightvalue", 3)]),
            uses([
              proof(
                goal(expr(eMul, mul, n2, n3)),
                by(fact("expression-eval.pl", clause(5)))
              ),
              proof(
                goal(value(n2, 2)),
                by(rule("expression-eval.pl", clause(9))),
                bindings([binding("Node", n2), binding("Value", 2)]),
                uses([
                  proof(
                    goal(number(n2, 2)),
                    by(fact("expression-eval.pl", clause(1)))
                  )
                ])
              ),
              proof(
                goal(value(n3, 3)),
                by(rule("expression-eval.pl", clause(9))),
                bindings([binding("Node", n3), binding("Value", 3)]),
                uses([
                  proof(
                    goal(number(n3, 3)),
                    by(fact("expression-eval.pl", clause(2)))
                  )
                ])
              ),
              proof(
                goal(is(6, *(2, 3))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(value(eSub, 6)),
            by(rule("expression-eval.pl", clause(11))),
            bindings([binding("Node", eSub), binding("Value", 6), binding("Left", n10), binding("Right", n4), binding("Leftvalue", 10), binding("Rightvalue", 4)]),
            uses([
              proof(
                goal(expr(eSub, sub, n10, n4)),
                by(fact("expression-eval.pl", clause(6)))
              ),
              proof(
                goal(value(n10, 10)),
                by(rule("expression-eval.pl", clause(9))),
                bindings([binding("Node", n10), binding("Value", 10)]),
                uses([
                  proof(
                    goal(number(n10, 10)),
                    by(fact("expression-eval.pl", clause(3)))
                  )
                ])
              ),
              proof(
                goal(value(n4, 4)),
                by(rule("expression-eval.pl", clause(9))),
                bindings([binding("Node", n4), binding("Value", 4)]),
                uses([
                  proof(
                    goal(number(n4, 4)),
                    by(fact("expression-eval.pl", clause(4)))
                  )
                ])
              ),
              proof(
                goal(is(6, '-'(10, 4))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(is(12, '+'(6, 6))),
            by(builtin(is, 2))
          )
        ])
      )
    ])
  )
).

