collectionLength(numbers, 3).
why(
  collectionLength(numbers, 3),
  proof(
    goal(collectionLength(numbers, 3)),
    by(rule("list-collection.pl", clause(3))),
    bindings([binding("N", 3), binding("List", [1, 2, 3])]),
    uses([
      proof(
        goal(collection(numbers, [1, 2, 3])),
        by(fact("list-collection.pl", clause(1)))
      ),
      proof(
        goal(length([1, 2, 3], 3)),
        by(library(length, 2))
      )
    ])
  )
).

collectionMember(numbers, 1).
why(
  collectionMember(numbers, 1),
  proof(
    goal(collectionMember(numbers, 1)),
    by(rule("list-collection.pl", clause(4))),
    bindings([binding("X", 1), binding("List", [1, 2, 3])]),
    uses([
      proof(
        goal(collection(numbers, [1, 2, 3])),
        by(fact("list-collection.pl", clause(1)))
      ),
      proof(
        goal(member(1, [1, 2, 3])),
        by(library(member, 2))
      )
    ])
  )
).

collectionMember(numbers, 2).
why(
  collectionMember(numbers, 2),
  proof(
    goal(collectionMember(numbers, 2)),
    by(rule("list-collection.pl", clause(4))),
    bindings([binding("X", 2), binding("List", [1, 2, 3])]),
    uses([
      proof(
        goal(collection(numbers, [1, 2, 3])),
        by(fact("list-collection.pl", clause(1)))
      ),
      proof(
        goal(member(2, [1, 2, 3])),
        by(library(member, 2))
      )
    ])
  )
).

collectionMember(numbers, 3).
why(
  collectionMember(numbers, 3),
  proof(
    goal(collectionMember(numbers, 3)),
    by(rule("list-collection.pl", clause(4))),
    bindings([binding("X", 3), binding("List", [1, 2, 3])]),
    uses([
      proof(
        goal(collection(numbers, [1, 2, 3])),
        by(fact("list-collection.pl", clause(1)))
      ),
      proof(
        goal(member(3, [1, 2, 3])),
        by(library(member, 2))
      )
    ])
  )
).

collectionAppend(letters, "abc").
why(
  collectionAppend(letters, "abc"),
  proof(
    goal(collectionAppend(letters, "abc")),
    by(rule("list-collection.pl", clause(5))),
    bindings([binding("Extended", "abc"), binding("List", "ab")]),
    uses([
      proof(
        goal(collection(letters, "ab")),
        by(fact("list-collection.pl", clause(2)))
      ),
      proof(
        goal(append("ab", "c", "abc")),
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
    bindings([binding("Head", a), binding("_tail", "b")]),
    uses([
      proof(
        goal(collection(letters, "ab")),
        by(fact("list-collection.pl", clause(2)))
      )
    ])
  )
).

tail(letters, "b").
why(
  tail(letters, "b"),
  proof(
    goal(tail(letters, "b")),
    by(rule("list-collection.pl", clause(7))),
    bindings([binding("Tail", "b"), binding("_head", a)]),
    uses([
      proof(
        goal(collection(letters, "ab")),
        by(fact("list-collection.pl", clause(2)))
      )
    ])
  )
).

