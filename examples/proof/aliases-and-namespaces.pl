value(nativeMath, 1.0).
why(
  value(nativeMath, 1.0),
  proof(
    goal(value(nativeMath, 1.0)),
    by(rule("aliases-and-namespaces.pl", clause(5))),
    bindings([binding("X", 1.0)]),
    uses([
      proof(
        goal(is(1.0, '+'(0.125, 0.875))),
        by(builtin(is, 2))
      )
    ])
  )
).

ok(nativeCompare, true).
why(
  ok(nativeCompare, true),
  proof(
    goal(ok(nativeCompare, true)),
    by(rule("aliases-and-namespaces.pl", clause(6))),
    uses([
      proof(
        goal(<(2, 3)),
        by(builtin(<, 2))
      )
    ])
  )
).

ok(nativeString, true).
why(
  ok(nativeString, true),
  proof(
    goal(ok(nativeString, true)),
    by(rule("aliases-and-namespaces.pl", clause(7))),
    uses([
      proof(
        goal(matches("scoped retail insight", "retail|medical")),
        by(builtin(matches, 2))
      )
    ])
  )
).

tail(nativeList, [b, c]).
why(
  tail(nativeList, [b, c]),
  proof(
    goal(tail(nativeList, [b, c])),
    by(rule("aliases-and-namespaces.pl", clause(8))),
    bindings([binding("Tail", [b, c])]),
    uses([
      proof(
        goal(rest([a, b, c], [b, c])),
        by(fact("<library>", clause(8))),
        bindings([binding("__anon3", a), binding("T", [b, c])])
      )
    ])
  )
).

label(vocabularyExample, "vocabulary names are ordinary predicate names").
why(
  label(vocabularyExample, "vocabulary names are ordinary predicate names"),
  proof(
    goal(label(vocabularyExample, "vocabulary names are ordinary predicate names")),
    by(rule("aliases-and-namespaces.pl", clause(10))),
    bindings([binding("Text", "vocabulary names are ordinary predicate names")]),
    uses([
      proof(
        goal(example_label(vocabularyExample, "vocabulary names are ordinary predicate names")),
        by(fact("aliases-and-namespaces.pl", clause(9)))
      )
    ])
  )
).

