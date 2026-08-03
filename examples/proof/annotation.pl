name(a, "Alice").
why(
  name(a, "Alice"),
  proof(
    goal(name(a, "Alice")),
    by(rule("annotation.pl", clause(5))),
    bindings([binding("S", a), binding("O", "Alice"), binding("_t", t), binding("Context", (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")))]),
    uses([
      proof(
        goal(annotation(t, (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")))),
        by(fact("annotation.pl", clause(1)))
      ),
      proof(
        goal(context_member((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), name(a, "Alice"))),
        by(rule("annotation.pl", clause(2))),
        bindings([binding("Left", name(a, "Alice")), binding("_right", (statedBy(t, bob), recorded(t, "2021-07-07"))), binding("Member", name(a, "Alice"))]),
        uses([
          proof(
            goal(context_member(name(a, "Alice"), name(a, "Alice"))),
            by(rule("annotation.pl", clause(4))),
            bindings([binding("Member", name(a, "Alice"))]),
            uses([
              proof(
                goal(\=(name(a, "Alice"), (_left, _right))),
                by(builtin(\=, 2))
              )
            ])
          )
        ])
      )
    ])
  )
).

log_nameOf(t, name(a, "Alice")).
why(
  log_nameOf(t, name(a, "Alice")),
  proof(
    goal(log_nameOf(t, name(a, "Alice"))),
    by(rule("annotation.pl", clause(6))),
    bindings([binding("T", t), binding("S", a), binding("O", "Alice"), binding("Context", (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")))]),
    uses([
      proof(
        goal(annotation(t, (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")))),
        by(fact("annotation.pl", clause(1)))
      ),
      proof(
        goal(context_member((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), name(a, "Alice"))),
        by(rule("annotation.pl", clause(2))),
        bindings([binding("Left", name(a, "Alice")), binding("_right", (statedBy(t, bob), recorded(t, "2021-07-07"))), binding("Member", name(a, "Alice"))]),
        uses([
          proof(
            goal(context_member(name(a, "Alice"), name(a, "Alice"))),
            by(rule("annotation.pl", clause(4))),
            bindings([binding("Member", name(a, "Alice"))]),
            uses([
              proof(
                goal(\=(name(a, "Alice"), (_left, _right))),
                by(builtin(\=, 2))
              )
            ])
          )
        ])
      )
    ])
  )
).

statedBy(t, bob).
why(
  statedBy(t, bob),
  proof(
    goal(statedBy(t, bob)),
    by(rule("annotation.pl", clause(7))),
    bindings([binding("S", t), binding("O", bob), binding("_t", t), binding("Context", (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")))]),
    uses([
      proof(
        goal(annotation(t, (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")))),
        by(fact("annotation.pl", clause(1)))
      ),
      proof(
        goal(context_member((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), statedBy(t, bob))),
        by(rule("annotation.pl", clause(3))),
        bindings([binding("_left", name(a, "Alice")), binding("Right", (statedBy(t, bob), recorded(t, "2021-07-07"))), binding("Member", statedBy(t, bob))]),
        uses([
          proof(
            goal(context_member((statedBy(t, bob), recorded(t, "2021-07-07")), statedBy(t, bob))),
            by(rule("annotation.pl", clause(2))),
            bindings([binding("Left", statedBy(t, bob)), binding("_right", recorded(t, "2021-07-07")), binding("Member", statedBy(t, bob))]),
            uses([
              proof(
                goal(context_member(statedBy(t, bob), statedBy(t, bob))),
                by(rule("annotation.pl", clause(4))),
                bindings([binding("Member", statedBy(t, bob))]),
                uses([
                  proof(
                    goal(\=(statedBy(t, bob), (_left, _right))),
                    by(builtin(\=, 2))
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

recorded(t, "2021-07-07").
why(
  recorded(t, "2021-07-07"),
  proof(
    goal(recorded(t, "2021-07-07")),
    by(rule("annotation.pl", clause(8))),
    bindings([binding("S", t), binding("O", "2021-07-07"), binding("_t", t), binding("Context", (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")))]),
    uses([
      proof(
        goal(annotation(t, (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")))),
        by(fact("annotation.pl", clause(1)))
      ),
      proof(
        goal(context_member((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), recorded(t, "2021-07-07"))),
        by(rule("annotation.pl", clause(3))),
        bindings([binding("_left", name(a, "Alice")), binding("Right", (statedBy(t, bob), recorded(t, "2021-07-07"))), binding("Member", recorded(t, "2021-07-07"))]),
        uses([
          proof(
            goal(context_member((statedBy(t, bob), recorded(t, "2021-07-07")), recorded(t, "2021-07-07"))),
            by(rule("annotation.pl", clause(3))),
            bindings([binding("_left", statedBy(t, bob)), binding("Right", recorded(t, "2021-07-07")), binding("Member", recorded(t, "2021-07-07"))]),
            uses([
              proof(
                goal(context_member(recorded(t, "2021-07-07"), recorded(t, "2021-07-07"))),
                by(rule("annotation.pl", clause(4))),
                bindings([binding("Member", recorded(t, "2021-07-07"))]),
                uses([
                  proof(
                    goal(\=(recorded(t, "2021-07-07"), (_left, _right))),
                    by(builtin(\=, 2))
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

