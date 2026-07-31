length(numbers, 3).
why(
  length(numbers, 3),
  proof(
    goal(length(numbers, 3)),
    by(rule("list-collection.pl", clause(8))),
    bindings([binding("N", 3), binding("List", [1, 2, 3])]),
    uses([
      proof(
        goal(collection(numbers, [1, 2, 3])),
        by(fact("list-collection.pl", clause(6)))
      ),
      proof(
        goal(length([1, 2, 3], 3)),
        by(builtin(length, 2))
      )
    ])
  )
).

member(numbers, 1).
why(
  member(numbers, 1),
  proof(
    goal(member(numbers, 1)),
    by(rule("list-collection.pl", clause(9))),
    bindings([binding("X", 1), binding("List", [1, 2, 3])]),
    uses([
      proof(
        goal(collection(numbers, [1, 2, 3])),
        by(fact("list-collection.pl", clause(6)))
      ),
      proof(
        goal(member(1, [1, 2, 3])),
        by(builtin(member, 2))
      )
    ])
  )
).

member(numbers, 2).
why(
  member(numbers, 2),
  proof(
    goal(member(numbers, 2)),
    by(rule("list-collection.pl", clause(9))),
    bindings([binding("X", 2), binding("List", [1, 2, 3])]),
    uses([
      proof(
        goal(collection(numbers, [1, 2, 3])),
        by(fact("list-collection.pl", clause(6)))
      ),
      proof(
        goal(member(2, [1, 2, 3])),
        by(builtin(member, 2))
      )
    ])
  )
).

member(numbers, 3).
why(
  member(numbers, 3),
  proof(
    goal(member(numbers, 3)),
    by(rule("list-collection.pl", clause(9))),
    bindings([binding("X", 3), binding("List", [1, 2, 3])]),
    uses([
      proof(
        goal(collection(numbers, [1, 2, 3])),
        by(fact("list-collection.pl", clause(6)))
      ),
      proof(
        goal(member(3, [1, 2, 3])),
        by(builtin(member, 2))
      )
    ])
  )
).

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
        by(builtin(append, 3))
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

