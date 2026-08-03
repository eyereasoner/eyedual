derivative_result(square, add(mul(const(1), var(x)), mul(var(x), const(1)))).
why(
  derivative_result(square, add(mul(const(1), var(x)), mul(var(x), const(1)))),
  proof(
    goal(derivative_result(square, add(mul(const(1), var(x)), mul(var(x), const(1))))),
    by(rule("symbolic-derivative.pl", clause(14))),
    bindings([binding("Name", square), binding("Derivative", add(mul(const(1), var(x)), mul(var(x), const(1)))), binding("Expr", mul(var(x), var(x)))]),
    uses([
      proof(
        goal(expr(square, mul(var(x), var(x)))),
        by(fact("symbolic-derivative.pl", clause(1)))
      ),
      proof(
        goal(d(mul(var(x), var(x)), x, add(mul(const(1), var(x)), mul(var(x), const(1))))),
        by(rule("symbolic-derivative.pl", clause(10))),
        bindings([binding("U", var(x)), binding("V", var(x)), binding("X", x), binding("Du", const(1)), binding("Dv", const(1))]),
        uses([
          proof(
            goal(d(var(x), x, const(1))),
            by(fact("symbolic-derivative.pl", clause(6))),
            bindings([binding("X", x)])
          ),
          proof(
            goal(d(var(x), x, const(1))),
            by(fact("symbolic-derivative.pl", clause(6))),
            bindings([binding("X", x)])
          )
        ])
      )
    ])
  )
).

derivative_result(linear_plus_const, add(const(1), const(0))).
why(
  derivative_result(linear_plus_const, add(const(1), const(0))),
  proof(
    goal(derivative_result(linear_plus_const, add(const(1), const(0)))),
    by(rule("symbolic-derivative.pl", clause(14))),
    bindings([binding("Name", linear_plus_const), binding("Derivative", add(const(1), const(0))), binding("Expr", add(var(x), const(3)))]),
    uses([
      proof(
        goal(expr(linear_plus_const, add(var(x), const(3)))),
        by(fact("symbolic-derivative.pl", clause(2)))
      ),
      proof(
        goal(d(add(var(x), const(3)), x, add(const(1), const(0)))),
        by(rule("symbolic-derivative.pl", clause(8))),
        bindings([binding("U", var(x)), binding("V", const(3)), binding("X", x), binding("Du", const(1)), binding("Dv", const(0))]),
        uses([
          proof(
            goal(d(var(x), x, const(1))),
            by(fact("symbolic-derivative.pl", clause(6))),
            bindings([binding("X", x)])
          ),
          proof(
            goal(d(const(3), x, const(0))),
            by(fact("symbolic-derivative.pl", clause(5))),
            bindings([binding("_c", 3), binding("_x", x)])
          )
        ])
      )
    ])
  )
).

derivative_result(product, add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))))))).
why(
  derivative_result(product, add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))))))),
  proof(
    goal(derivative_result(product, add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0)))))))),
    by(rule("symbolic-derivative.pl", clause(14))),
    bindings([binding("Name", product), binding("Derivative", add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))))))), binding("Expr", mul(add(var(x), const(1)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))))]),
    uses([
      proof(
        goal(expr(product, mul(add(var(x), const(1)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))))),
        by(fact("symbolic-derivative.pl", clause(3)))
      ),
      proof(
        goal(d(mul(add(var(x), const(1)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), x, add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0)))))))),
        by(rule("symbolic-derivative.pl", clause(10))),
        bindings([binding("U", add(var(x), const(1))), binding("V", mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), binding("X", x), binding("Du", add(const(1), const(0))), binding("Dv", add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0)))))]),
        uses([
          proof(
            goal(d(add(var(x), const(1)), x, add(const(1), const(0)))),
            by(rule("symbolic-derivative.pl", clause(8))),
            bindings([binding("U", var(x)), binding("V", const(1)), binding("X", x), binding("Du", const(1)), binding("Dv", const(0))]),
            uses([
              proof(
                goal(d(var(x), x, const(1))),
                by(fact("symbolic-derivative.pl", clause(6))),
                bindings([binding("X", x)])
              ),
              proof(
                goal(d(const(1), x, const(0))),
                by(fact("symbolic-derivative.pl", clause(5))),
                bindings([binding("_c", 1), binding("_x", x)])
              )
            ])
          ),
          proof(
            goal(d(mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3))), x, add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0)))))),
            by(rule("symbolic-derivative.pl", clause(10))),
            bindings([binding("U", add(pow(var(x), 2), const(2))), binding("V", add(pow(var(x), 3), const(3))), binding("X", x), binding("Du", add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0))), binding("Dv", add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0)))]),
            uses([
              proof(
                goal(d(add(pow(var(x), 2), const(2)), x, add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)))),
                by(rule("symbolic-derivative.pl", clause(8))),
                bindings([binding("U", pow(var(x), 2)), binding("V", const(2)), binding("X", x), binding("Du", mul(mul(const(2), pow(var(x), 1)), const(1))), binding("Dv", const(0))]),
                uses([
                  proof(
                    goal(d(pow(var(x), 2), x, mul(mul(const(2), pow(var(x), 1)), const(1)))),
                    by(rule("symbolic-derivative.pl", clause(12))),
                    bindings([binding("U", var(x)), binding("N", 2), binding("X", x), binding("N1", 1), binding("Du", const(1))]),
                    uses([
                      proof(
                        goal(is(1, '-'(2, 1))),
                        by(builtin(is, 2))
                      ),
                      proof(
                        goal(d(var(x), x, const(1))),
                        by(fact("symbolic-derivative.pl", clause(6))),
                        bindings([binding("X", x)])
                      )
                    ])
                  ),
                  proof(
                    goal(d(const(2), x, const(0))),
                    by(fact("symbolic-derivative.pl", clause(5))),
                    bindings([binding("_c", 2), binding("_x", x)])
                  )
                ])
              ),
              proof(
                goal(d(add(pow(var(x), 3), const(3)), x, add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0)))),
                by(rule("symbolic-derivative.pl", clause(8))),
                bindings([binding("U", pow(var(x), 3)), binding("V", const(3)), binding("X", x), binding("Du", mul(mul(const(3), pow(var(x), 2)), const(1))), binding("Dv", const(0))]),
                uses([
                  proof(
                    goal(d(pow(var(x), 3), x, mul(mul(const(3), pow(var(x), 2)), const(1)))),
                    by(rule("symbolic-derivative.pl", clause(12))),
                    bindings([binding("U", var(x)), binding("N", 3), binding("X", x), binding("N1", 2), binding("Du", const(1))]),
                    uses([
                      proof(
                        goal(is(2, '-'(3, 1))),
                        by(builtin(is, 2))
                      ),
                      proof(
                        goal(d(var(x), x, const(1))),
                        by(fact("symbolic-derivative.pl", clause(6))),
                        bindings([binding("X", x)])
                      )
                    ])
                  ),
                  proof(
                    goal(d(const(3), x, const(0))),
                    by(fact("symbolic-derivative.pl", clause(5))),
                    bindings([binding("_c", 3), binding("_x", x)])
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

derivative_result(nested_log, divide(divide(const(1), var(x)), log(var(x)))).
why(
  derivative_result(nested_log, divide(divide(const(1), var(x)), log(var(x)))),
  proof(
    goal(derivative_result(nested_log, divide(divide(const(1), var(x)), log(var(x))))),
    by(rule("symbolic-derivative.pl", clause(14))),
    bindings([binding("Name", nested_log), binding("Derivative", divide(divide(const(1), var(x)), log(var(x)))), binding("Expr", log(log(var(x))))]),
    uses([
      proof(
        goal(expr(nested_log, log(log(var(x))))),
        by(fact("symbolic-derivative.pl", clause(4)))
      ),
      proof(
        goal(d(log(log(var(x))), x, divide(divide(const(1), var(x)), log(var(x))))),
        by(rule("symbolic-derivative.pl", clause(13))),
        bindings([binding("U", log(var(x))), binding("X", x), binding("Du", divide(const(1), var(x)))]),
        uses([
          proof(
            goal(d(log(var(x)), x, divide(const(1), var(x)))),
            by(rule("symbolic-derivative.pl", clause(13))),
            bindings([binding("U", var(x)), binding("X", x), binding("Du", const(1))]),
            uses([
              proof(
                goal(d(var(x), x, const(1))),
                by(fact("symbolic-derivative.pl", clause(6))),
                bindings([binding("X", x)])
              )
            ])
          )
        ])
      )
    ])
  )
).

