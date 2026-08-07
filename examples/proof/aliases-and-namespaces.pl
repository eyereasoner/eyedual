value(nativeMath, 1.0).
why(
  value(nativeMath, 1.0),
  proof(
    goal(value(nativeMath, 1.0)),
    by(rule("aliases-and-namespaces.pl", clause(1))),
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
    by(rule("aliases-and-namespaces.pl", clause(2))),
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
    by(rule("aliases-and-namespaces.pl", clause(3))),
    uses([
      proof(
        goal(matches('scoped retail insight', 'retail|medical')),
        by(library(matches, 2))
      )
    ])
  )
).

tail(nativeList, "bc").
why(
  tail(nativeList, "bc"),
  proof(
    goal(tail(nativeList, "bc")),
    by(rule("aliases-and-namespaces.pl", clause(4))),
    bindings([binding("Tail", "bc"), binding("_head", a)]),
    uses([
      proof(
        goal(=("abc", "abc")),
        by(builtin(=, 2))
      )
    ])
  )
).

label(vocabularyExample, "vocabulary names are ordinary predicate names").
why(
  label(vocabularyExample, "vocabulary names are ordinary predicate names"),
  proof(
    goal(label(vocabularyExample, "vocabulary names are ordinary predicate names")),
    by(rule("aliases-and-namespaces.pl", clause(6))),
    bindings([binding("Text", "vocabulary names are ordinary predicate names")]),
    uses([
      proof(
        goal(example_label(vocabularyExample, "vocabulary names are ordinary predicate names")),
        by(fact("aliases-and-namespaces.pl", clause(5)))
      )
    ])
  )
).

