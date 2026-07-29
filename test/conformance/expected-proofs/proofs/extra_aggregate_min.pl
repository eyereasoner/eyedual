answer(aggregate_min, 1, a).
why(
  answer(aggregate_min, 1, a),
  proof(
    goal(answer(aggregate_min, 1, a)),
    by(rule("<stdin>", clause(4))),
    bindings([binding("Key", 1), binding("Value", a)]),
    uses([
      proof(
        goal(aggregate_min(Key, Value, score(Key, Value), 1, a)),
        by(rule("<library>", clause(54))),
        bindings([binding("Goal", score(Key, Value)), binding("BestKey", 1), binding("BestValue", a), binding("Pairs", [pair(2, b), pair(1, a)])]),
        uses([
          proof(
            goal(findall(pair(Key, Value), score(Key, Value), [pair(2, b), pair(1, a)])),
            by(builtin(findall, 3))
          ),
          proof(
            goal(aggregate_min_pairs([pair(2, b), pair(1, a)], 1, a)),
            by(rule("<library>", clause(55))),
            bindings([binding("K", 2), binding("V", b), binding("Pairs", [pair(1, a)]), binding("BestKey", 1), binding("BestValue", a)]),
            uses([
              proof(
                goal(aggregate_min_acc([pair(1, a)], 2, b, 1, a)),
                by(rule("<library>", clause(57))),
                bindings([binding("K", 1), binding("V", a), binding("Pairs", []), binding("K0", 2), binding("V0", b), binding("BestKey", 1), binding("BestValue", a), binding("K1", 1), binding("V1", a)]),
                uses([
                  proof(
                    goal(';'(->(@<(1, 2), (=(1, 1), =(a, a))), (=(1, 2), =(a, b)))),
                    by(builtin(';', 2))
                  ),
                  proof(
                    goal(aggregate_min_acc([], 1, a, 1, a)),
                    by(fact("<library>", clause(56))),
                    bindings([binding("K", 1), binding("V", a)])
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

