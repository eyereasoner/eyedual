report(shape, shape(edge, 3)).
why(
  report(shape, shape(edge, 3)),
  proof(
    goal(report(shape, shape(edge, 3))),
    by(rule("term-tools.pl", clause(3))),
    bindings([binding("Name", edge), binding("Arity", 3)]),
    uses([
      proof(
        goal(functor(edge(a, b, 3), edge, 3)),
        by(builtin(functor, 3))
      )
    ])
  )
).

report(second_argument, b).
why(
  report(second_argument, b),
  proof(
    goal(report(second_argument, b)),
    by(rule("term-tools.pl", clause(4))),
    bindings([binding("Node", b)]),
    uses([
      proof(
        goal(arg(2, edge(a, b, 3), b)),
        by(builtin(arg, 3))
      )
    ])
  )
).

report(parts, parts(edge, [a, b, 3])).
why(
  report(parts, parts(edge, [a, b, 3])),
  proof(
    goal(report(parts, parts(edge, [a, b, 3]))),
    by(rule("term-tools.pl", clause(5))),
    bindings([binding("Name", edge), binding("Args", [a, b, 3])]),
    uses([
      proof(
        goal('=..'(edge(a, b, 3), [edge, a, b, 3])),
        by(builtin('=..', 2))
      )
    ])
  )
).

report(rebuilt, edge(c, d, 5)).
why(
  report(rebuilt, edge(c, d, 5)),
  proof(
    goal(report(rebuilt, edge(c, d, 5))),
    by(rule("term-tools.pl", clause(6))),
    bindings([binding("Term", edge(c, d, 5))]),
    uses([
      proof(
        goal('=..'(edge(c, d, 5), [edge, c, d, 5])),
        by(builtin('=..', 2))
      )
    ])
  )
).

report(rendered, 'edge(a, [b, c])').
why(
  report(rendered, 'edge(a, [b, c])'),
  proof(
    goal(report(rendered, 'edge(a, [b, c])')),
    by(rule("term-tools.pl", clause(7))),
    bindings([binding("Text", 'edge(a, [b, c])')]),
    uses([
      proof(
        goal(term_string(edge(a, "bc"), 'edge(a, [b, c])')),
        by(library(term_string, 2))
      )
    ])
  )
).

report(all_weights_positive, yes).
why(
  report(all_weights_positive, yes),
  proof(
    goal(report(all_weights_positive, yes)),
    by(rule("term-tools.pl", clause(8))),
    uses([
      proof(
        goal('\\+'(nonpositive_edge)),
        by(builtin('\\+', 1))
      )
    ])
  )
).

