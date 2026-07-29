append(letters, [a, b, c]).
why(
  append(letters, [a, b, c]),
  proof(
    goal(append(letters, [a, b, c])),
    by(rule("list-collection.pl", clause(10))),
    bindings([binding("Extended", [a, b, c]), binding("List", [a, b])]),
    uses([
      proof(
        goal(collection(letters, [a, b])),
        by(fact("list-collection.pl", clause(7)))
      ),
      proof(
        goal(append([a, b], [c], [a, b, c])),
        by(rule("<library>", clause(2))),
        bindings([binding("X", a), binding("Xs", [b]), binding("Ys", [c]), binding("Zs", [b, c])]),
        uses([
          proof(
            goal(append([b], [c], [b, c])),
            by(rule("<library>", clause(2))),
            bindings([binding("X", b), binding("Xs", []), binding("Ys", [c]), binding("Zs", [c])]),
            uses([
              proof(
                goal(append([], [c], [c])),
                by(fact("<library>", clause(1))),
                bindings([binding("Ys", [c])])
              )
            ])
          )
        ])
      )
    ])
  )
).

head(letters, a).
why(
  head(letters, a),
  proof(
    goal(head(letters, a)),
    by(rule("list-collection.pl", clause(11))),
    bindings([binding("Head", a), binding("_tail", [b])]),
    uses([
      proof(
        goal(collection(letters, [a, b])),
        by(fact("list-collection.pl", clause(7)))
      )
    ])
  )
).

tail(letters, [b]).
why(
  tail(letters, [b]),
  proof(
    goal(tail(letters, [b])),
    by(rule("list-collection.pl", clause(12))),
    bindings([binding("Tail", [b]), binding("_head", a)]),
    uses([
      proof(
        goal(collection(letters, [a, b])),
        by(fact("list-collection.pl", clause(7)))
      )
    ])
  )
).

