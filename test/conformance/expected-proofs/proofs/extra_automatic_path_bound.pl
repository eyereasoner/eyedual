answer(table_path_bound, b).
why(
  answer(table_path_bound, b),
  proof(
    goal(answer(table_path_bound, b)),
    by(rule("<stdin>", clause(5))),
    bindings([binding("X", b)]),
    uses([
      proof(
        goal(path(a, b)),
        by(rule("<stdin>", clause(3))),
        bindings([binding("X", a), binding("Y", b)]),
        uses([
          proof(
            goal(edge(a, b)),
            by(fact("<stdin>", clause(1)))
          )
        ])
      )
    ])
  )
).

answer(table_path_bound, c).
why(
  answer(table_path_bound, c),
  proof(
    goal(answer(table_path_bound, c)),
    by(rule("<stdin>", clause(5))),
    bindings([binding("X", c)]),
    uses([
      proof(
        goal(path(a, c)),
        by(rule("<stdin>", clause(4))),
        bindings([binding("X", a), binding("Z", c), binding("Y", b)]),
        uses([
          proof(
            goal(edge(a, b)),
            by(fact("<stdin>", clause(1)))
          ),
          proof(
            goal(path(b, c)),
            by(rule("<stdin>", clause(3))),
            bindings([binding("X", b), binding("Y", c)]),
            uses([
              proof(
                goal(edge(b, c)),
                by(fact("<stdin>", clause(2)))
              )
            ])
          )
        ])
      )
    ])
  )
).

