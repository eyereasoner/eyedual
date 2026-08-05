partialEvalAnswer(residual(static_branch), const(11)).
why(
  partialEvalAnswer(residual(static_branch), const(11)),
  proof(
    goal(partialEvalAnswer(residual(static_branch), const(11))),
    by(rule("partial-evaluator.pl", clause(20))),
    bindings([binding("Name", static_branch), binding("Residual", const(11))]),
    uses([
      proof(
        goal(residual_program(static_branch, const(11))),
        by(rule("partial-evaluator.pl", clause(19))),
        bindings([binding("Name", static_branch), binding("Residual", const(11)), binding("Expr", if(bool(true), add(var(x), const(1)), mul(var(y), const(999)))), binding("Env", [bind(x, const(10))])]),
        uses([
          proof(
            goal(program(static_branch, if(bool(true), add(var(x), const(1)), mul(var(y), const(999))), [bind(x, const(10))])),
            by(fact("partial-evaluator.pl", clause(2)))
          ),
          proof(
            goal(pe([bind(x, const(10))], if(bool(true), add(var(x), const(1)), mul(var(y), const(999))), const(11))),
            by(rule("partial-evaluator.pl", clause(16))),
            bindings([binding("Env", [bind(x, const(10))]), binding("Cond", bool(true)), binding("Then", add(var(x), const(1))), binding("Else", mul(var(y), const(999))), binding("Residual", const(11))]),
            uses([
              proof(
                goal(pe([bind(x, const(10))], bool(true), bool(true))),
                by(fact("partial-evaluator.pl", clause(9))),
                bindings([binding("__anon5", [bind(x, const(10))]), binding("B", true)])
              ),
              proof(
                goal(pe([bind(x, const(10))], add(var(x), const(1)), const(11))),
                by(rule("partial-evaluator.pl", clause(12))),
                bindings([binding("Env", [bind(x, const(10))]), binding("Left", var(x)), binding("Right", const(1)), binding("Sum", 11), binding("A", 10), binding("B", 1)]),
                uses([
                  proof(
                    goal(pe([bind(x, const(10))], var(x), const(10))),
                    by(rule("partial-evaluator.pl", clause(10))),
                    bindings([binding("Env", [bind(x, const(10))]), binding("Name", x), binding("Value", const(10))]),
                    uses([
                      proof(
                        goal(known_var([bind(x, const(10))], x, const(10))),
                        by(rule("partial-evaluator.pl", clause(6))),
                        bindings([binding("Env", [bind(x, const(10))]), binding("Name", x), binding("Value", const(10))]),
                        uses([
                          proof(
                            goal(lookup(x, [bind(x, const(10))], const(10))),
                            by(fact("partial-evaluator.pl", clause(4))),
                            bindings([binding("Name", x), binding("Value", const(10)), binding("__anon0", [])])
                          )
                        ])
                      )
                    ])
                  ),
                  proof(
                    goal(pe([bind(x, const(10))], const(1), const(1))),
                    by(fact("partial-evaluator.pl", clause(8))),
                    bindings([binding("__anon4", [bind(x, const(10))]), binding("N", 1)])
                  ),
                  proof(
                    goal(is(11, '+'(10, 1))),
                    by(builtin(is, 2))
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

