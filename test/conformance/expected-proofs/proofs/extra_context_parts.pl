answer(context_parts, alpha, []).
why(
  answer(context_parts, alpha, []),
  proof(
    goal(answer(context_parts, alpha, [])),
    by(rule("<stdin>", clause(4))),
    bindings([binding("Name", alpha), binding("Args", [])]),
    uses([
      proof(
        goal(context_parts(alpha, [])),
        by(rule("<stdin>", clause(3))),
        bindings([binding("Name", alpha), binding("Args", []), binding("Statement", alpha)]),
        uses([
          proof(
            goal(context_statement(alpha)),
            by(fact("<stdin>", clause(1)))
          ),
          proof(
            goal('=..'(alpha, [alpha])),
            by(builtin('=..', 2))
          ),
          proof(
            goal(atom(alpha)),
            by(builtin(atom, 1))
          )
        ])
      )
    ])
  )
).

answer(context_parts, beta, [2]).
why(
  answer(context_parts, beta, [2]),
  proof(
    goal(answer(context_parts, beta, [2])),
    by(rule("<stdin>", clause(4))),
    bindings([binding("Name", beta), binding("Args", [2])]),
    uses([
      proof(
        goal(context_parts(beta, [2])),
        by(rule("<stdin>", clause(3))),
        bindings([binding("Name", beta), binding("Args", [2]), binding("Statement", beta(2))]),
        uses([
          proof(
            goal(context_statement(beta(2))),
            by(fact("<stdin>", clause(2)))
          ),
          proof(
            goal('=..'(beta(2), [beta, 2])),
            by(builtin('=..', 2))
          ),
          proof(
            goal(atom(beta)),
            by(builtin(atom, 1))
          )
        ])
      )
    ])
  )
).

