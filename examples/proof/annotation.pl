name(a, "Alice").
why(
  name(a, "Alice"),
  proof(
    goal(name(a, "Alice")),
    by(rule("annotation.pl", clause(6))),
    bindings([binding("S", a), binding("O", "Alice"), binding("_t", t), binding("Context", (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")))]),
    uses([
      proof(
        goal(annotation(t, (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")))),
        by(fact("annotation.pl", clause(5)))
      ),
      proof(
        goal(holds((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), name(a, "Alice"))),
        by(builtin(holds, 2))
      )
    ])
  )
).

log_nameOf(t, name(a, "Alice")).
why(
  log_nameOf(t, name(a, "Alice")),
  proof(
    goal(log_nameOf(t, name(a, "Alice"))),
    by(rule("annotation.pl", clause(7))),
    bindings([binding("T", t), binding("S", a), binding("O", "Alice"), binding("Context", (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")))]),
    uses([
      proof(
        goal(annotation(t, (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")))),
        by(fact("annotation.pl", clause(5)))
      ),
      proof(
        goal(holds((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), name(a, "Alice"))),
        by(builtin(holds, 2))
      )
    ])
  )
).

statedBy(t, bob).
why(
  statedBy(t, bob),
  proof(
    goal(statedBy(t, bob)),
    by(rule("annotation.pl", clause(8))),
    bindings([binding("S", t), binding("O", bob), binding("_t", t), binding("Context", (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")))]),
    uses([
      proof(
        goal(annotation(t, (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")))),
        by(fact("annotation.pl", clause(5)))
      ),
      proof(
        goal(holds((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), statedBy(t, bob))),
        by(builtin(holds, 2))
      )
    ])
  )
).

recorded(t, "2021-07-07").
why(
  recorded(t, "2021-07-07"),
  proof(
    goal(recorded(t, "2021-07-07")),
    by(rule("annotation.pl", clause(9))),
    bindings([binding("S", t), binding("O", "2021-07-07"), binding("_t", t), binding("Context", (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")))]),
    uses([
      proof(
        goal(annotation(t, (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")))),
        by(fact("annotation.pl", clause(5)))
      ),
      proof(
        goal(holds((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), recorded(t, "2021-07-07"))),
        by(builtin(holds, 2))
      )
    ])
  )
).

