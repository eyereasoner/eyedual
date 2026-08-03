different(alice, bob).
why(
  different(alice, bob),
  proof(
    goal(different(alice, bob)),
    by(rule("herbrand-semantics.pl", clause(1))),
    uses([
      proof(
        goal(\=(alice, bob)),
        by(builtin(\=, 2))
      )
    ])
  )
).

different(ticket(alice), ticket(bob)).
why(
  different(ticket(alice), ticket(bob)),
  proof(
    goal(different(ticket(alice), ticket(bob))),
    by(rule("herbrand-semantics.pl", clause(2))),
    uses([
      proof(
        goal(\=(ticket(alice), ticket(bob))),
        by(builtin(\=, 2))
      )
    ])
  )
).

