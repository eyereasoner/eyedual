sameInverse(x, i, j).
why(
  sameInverse(x, i, j),
  proof(
    goal(sameInverse(x, i, j)),
    by(rule("group-inverse-uniqueness.pl", clause(16))),
    bindings([binding("A", x), binding("B", i), binding("C", j)]),
    uses([
      proof(
        goal(leftInverse(x, i)),
        by(rule("group-inverse-uniqueness.pl", clause(14))),
        bindings([binding("A", x), binding("B", i)]),
        uses([
          proof(
            goal(group_op(i, x, e)),
            by(fact("group-inverse-uniqueness.pl", clause(7)))
          )
        ])
      ),
      proof(
        goal(rightInverse(x, j)),
        by(rule("group-inverse-uniqueness.pl", clause(15))),
        bindings([binding("A", x), binding("B", j)]),
        uses([
          proof(
            goal(group_op(x, j, e)),
            by(fact("group-inverse-uniqueness.pl", clause(8)))
          )
        ])
      ),
      proof(
        goal(sameTerm(i, j)),
        by(fact("group-inverse-uniqueness.pl", clause(12)))
      ),
      proof(
        goal(\=(i, j)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameInverse(x, j, i).
why(
  sameInverse(x, j, i),
  proof(
    goal(sameInverse(x, j, i)),
    by(rule("group-inverse-uniqueness.pl", clause(16))),
    bindings([binding("A", x), binding("B", j), binding("C", i)]),
    uses([
      proof(
        goal(leftInverse(x, j)),
        by(rule("group-inverse-uniqueness.pl", clause(14))),
        bindings([binding("A", x), binding("B", j)]),
        uses([
          proof(
            goal(group_op(j, x, e)),
            by(fact("group-inverse-uniqueness.pl", clause(9)))
          )
        ])
      ),
      proof(
        goal(rightInverse(x, i)),
        by(rule("group-inverse-uniqueness.pl", clause(15))),
        bindings([binding("A", x), binding("B", i)]),
        uses([
          proof(
            goal(group_op(x, i, e)),
            by(fact("group-inverse-uniqueness.pl", clause(10)))
          )
        ])
      ),
      proof(
        goal(sameTerm(j, i)),
        by(fact("group-inverse-uniqueness.pl", clause(13)))
      ),
      proof(
        goal(\=(j, i)),
        by(builtin(\=, 2))
      )
    ])
  )
).

