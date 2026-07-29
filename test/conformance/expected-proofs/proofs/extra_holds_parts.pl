answer(holds_parts, alpha, []).
why(
  answer(holds_parts, alpha, []),
  proof(
    goal(answer(holds_parts, alpha, [])),
    by(rule("<stdin>", clause(2))),
    bindings([binding("Name", alpha), binding("Args", [])]),
    uses([
      proof(
        goal(holds((alpha, beta(2)), alpha, [])),
        by(rule("<library>", clause(73))),
        bindings([binding("Context", (alpha, beta(2))), binding("Name", alpha), binding("Arguments", []), binding("Member", alpha)]),
        uses([
          proof(
            goal(holds((alpha, beta(2)), alpha)),
            by(rule("<library>", clause(70))),
            bindings([binding("Left", alpha), binding("Right", beta(2)), binding("Member", alpha)]),
            uses([
              proof(
                goal(holds(alpha, alpha)),
                by(rule("<library>", clause(72))),
                bindings([binding("Member", alpha)]),
                uses([
                  proof(
                    goal(\=(alpha, (__anon17, __anon18))),
                    by(builtin(\=, 2))
                  )
                ])
              )
            ])
          ),
          proof(
            goal(';'(atom(alpha), compound(alpha))),
            by(builtin(';', 2))
          ),
          proof(
            goal('=..'(alpha, [alpha])),
            by(builtin('=..', 2))
          )
        ])
      )
    ])
  )
).

answer(holds_parts, beta, [2]).
why(
  answer(holds_parts, beta, [2]),
  proof(
    goal(answer(holds_parts, beta, [2])),
    by(rule("<stdin>", clause(2))),
    bindings([binding("Name", beta), binding("Args", [2])]),
    uses([
      proof(
        goal(holds((alpha, beta(2)), beta, [2])),
        by(rule("<library>", clause(73))),
        bindings([binding("Context", (alpha, beta(2))), binding("Name", beta), binding("Arguments", [2]), binding("Member", beta(2))]),
        uses([
          proof(
            goal(holds((alpha, beta(2)), beta(2))),
            by(rule("<library>", clause(71))),
            bindings([binding("Left", alpha), binding("Right", beta(2)), binding("Member", beta(2))]),
            uses([
              proof(
                goal(holds(beta(2), beta(2))),
                by(rule("<library>", clause(72))),
                bindings([binding("Member", beta(2))]),
                uses([
                  proof(
                    goal(\=(beta(2), (__anon17, __anon18))),
                    by(builtin(\=, 2))
                  )
                ])
              )
            ])
          ),
          proof(
            goal(';'(atom(beta(2)), compound(beta(2)))),
            by(builtin(';', 2))
          ),
          proof(
            goal('=..'(beta(2), [beta, 2])),
            by(builtin('=..', 2))
          )
        ])
      )
    ])
  )
).

