length(numbers, 3).
why(
  length(numbers, 3),
  proof(
    goal(length(numbers, 3)),
    by(library(length, 2))
  )
).

member(numbers, 1).
why(
  member(numbers, 1),
  proof(
    goal(member(numbers, 1)),
    by(library(member, 2))
  )
).

member(numbers, 2).
why(
  member(numbers, 2),
  proof(
    goal(member(numbers, 2)),
    by(library(member, 2))
  )
).

member(numbers, 3).
why(
  member(numbers, 3),
  proof(
    goal(member(numbers, 3)),
    by(library(member, 2))
  )
).

append(letters, [a, b, c]).
why(
  append(letters, [a, b, c]),
  proof(
    goal(append(letters, [a, b, c])),
    by(rule("list-collection.pl", clause(5))),
    bindings([binding("Extended", [a, b, c]), binding("List", [a, b])]),
    uses([
      proof(
        goal(collection(letters, [a, b])),
        by(fact("list-collection.pl", clause(2)))
      ),
      proof(
        goal(append([a, b], [c], [a, b, c])),
        by(library(append, 3))
      )
    ])
  )
).

head(letters, a).
why(
  head(letters, a),
  proof(
    goal(head(letters, a)),
    by(rule("list-collection.pl", clause(6))),
    bindings([binding("Head", a), binding("_tail", [b])]),
    uses([
      proof(
        goal(collection(letters, [a, b])),
        by(fact("list-collection.pl", clause(2)))
      )
    ])
  )
).

tail(letters, [b]).
why(
  tail(letters, [b]),
  proof(
    goal(tail(letters, [b])),
    by(rule("list-collection.pl", clause(7))),
    bindings([binding("Tail", [b]), binding("_head", a)]),
    uses([
      proof(
        goal(collection(letters, [a, b])),
        by(fact("list-collection.pl", clause(2)))
      )
    ])
  )
).

