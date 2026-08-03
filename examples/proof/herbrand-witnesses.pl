has_parent(alice, parent_of(alice)).
why(
  has_parent(alice, parent_of(alice)),
  proof(
    goal(has_parent(alice, parent_of(alice))),
    by(rule("herbrand-witnesses.pl", clause(6))),
    bindings([binding("Child", alice)]),
    uses([
      proof(
        goal(person(alice)),
        by(fact("herbrand-witnesses.pl", clause(1)))
      )
    ])
  )
).

has_parent(bob, parent_of(bob)).
why(
  has_parent(bob, parent_of(bob)),
  proof(
    goal(has_parent(bob, parent_of(bob))),
    by(rule("herbrand-witnesses.pl", clause(6))),
    bindings([binding("Child", bob)]),
    uses([
      proof(
        goal(person(bob)),
        by(fact("herbrand-witnesses.pl", clause(2)))
      )
    ])
  )
).

registration(alice, logic, registration_of(alice, logic)).
why(
  registration(alice, logic, registration_of(alice, logic)),
  proof(
    goal(registration(alice, logic, registration_of(alice, logic))),
    by(rule("herbrand-witnesses.pl", clause(7))),
    bindings([binding("Student", alice), binding("Course", logic)]),
    uses([
      proof(
        goal(takes(alice, logic)),
        by(fact("herbrand-witnesses.pl", clause(3)))
      )
    ])
  )
).

registration(alice, math, registration_of(alice, math)).
why(
  registration(alice, math, registration_of(alice, math)),
  proof(
    goal(registration(alice, math, registration_of(alice, math))),
    by(rule("herbrand-witnesses.pl", clause(7))),
    bindings([binding("Student", alice), binding("Course", math)]),
    uses([
      proof(
        goal(takes(alice, math)),
        by(fact("herbrand-witnesses.pl", clause(4)))
      )
    ])
  )
).

registration(bob, logic, registration_of(bob, logic)).
why(
  registration(bob, logic, registration_of(bob, logic)),
  proof(
    goal(registration(bob, logic, registration_of(bob, logic))),
    by(rule("herbrand-witnesses.pl", clause(7))),
    bindings([binding("Student", bob), binding("Course", logic)]),
    uses([
      proof(
        goal(takes(bob, logic)),
        by(fact("herbrand-witnesses.pl", clause(5)))
      )
    ])
  )
).

same_witness(parent_of_alice, true).
why(
  same_witness(parent_of_alice, true),
  proof(
    goal(same_witness(parent_of_alice, true)),
    by(rule("herbrand-witnesses.pl", clause(8))),
    uses([
      proof(
        goal(=(parent_of(alice), parent_of(alice))),
        by(builtin(=, 2))
      )
    ])
  )
).

distinct_witnesses(alice_logic_vs_alice_math, true).
why(
  distinct_witnesses(alice_logic_vs_alice_math, true),
  proof(
    goal(distinct_witnesses(alice_logic_vs_alice_math, true)),
    by(rule("herbrand-witnesses.pl", clause(9))),
    uses([
      proof(
        goal(\=(registration_of(alice, logic), registration_of(alice, math))),
        by(builtin(\=, 2))
      )
    ])
  )
).

