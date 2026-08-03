reachable(reachability_case, path(a, f)).
why(
  reachable(reachability_case, path(a, f)),
  proof(
    goal(reachable(reachability_case, path(a, f))),
    by(rule("graph-reachability.pl", clause(11))),
    uses([
      proof(
        goal(is_reachable(a, f)),
        by(rule("graph-reachability.pl", clause(10))),
        bindings([binding("Start", a), binding("Goal", f)]),
        uses([
          proof(
            goal(reachable(a, f, [a])),
            by(rule("graph-reachability.pl", clause(9))),
            bindings([binding("Start", a), binding("Goal", f), binding("Visited", [a]), binding("Next", b)]),
            uses([
              proof(
                goal(edge(a, b)),
                by(fact("graph-reachability.pl", clause(1)))
              ),
              proof(
                goal('\\+'(member(b, [a]))),
                by(builtin('\\+', 1))
              ),
              proof(
                goal(reachable(b, f, [b, a])),
                by(rule("graph-reachability.pl", clause(9))),
                bindings([binding("Start", b), binding("Goal", f), binding("Visited", [b, a]), binding("Next", d)]),
                uses([
                  proof(
                    goal(edge(b, d)),
                    by(fact("graph-reachability.pl", clause(3)))
                  ),
                  proof(
                    goal('\\+'(member(d, [b, a]))),
                    by(builtin('\\+', 1))
                  ),
                  proof(
                    goal(reachable(d, f, [d, b, a])),
                    by(rule("graph-reachability.pl", clause(9))),
                    bindings([binding("Start", d), binding("Goal", f), binding("Visited", [d, b, a]), binding("Next", f)]),
                    uses([
                      proof(
                        goal(edge(d, f)),
                        by(fact("graph-reachability.pl", clause(5)))
                      ),
                      proof(
                        goal('\\+'(member(f, [d, b, a]))),
                        by(builtin('\\+', 1))
                      ),
                      proof(
                        goal(reachable(f, f, [f, d, b, a])),
                        by(fact("graph-reachability.pl", clause(8))),
                        bindings([binding("Node", f), binding("_visited", [f, d, b, a])])
                      )
                    ])
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

reachable(reachability_case, path(c, g)).
why(
  reachable(reachability_case, path(c, g)),
  proof(
    goal(reachable(reachability_case, path(c, g))),
    by(rule("graph-reachability.pl", clause(12))),
    uses([
      proof(
        goal(is_reachable(c, g)),
        by(rule("graph-reachability.pl", clause(10))),
        bindings([binding("Start", c), binding("Goal", g)]),
        uses([
          proof(
            goal(reachable(c, g, [c])),
            by(rule("graph-reachability.pl", clause(9))),
            bindings([binding("Start", c), binding("Goal", g), binding("Visited", [c]), binding("Next", e)]),
            uses([
              proof(
                goal(edge(c, e)),
                by(fact("graph-reachability.pl", clause(4)))
              ),
              proof(
                goal('\\+'(member(e, [c]))),
                by(builtin('\\+', 1))
              ),
              proof(
                goal(reachable(e, g, [e, c])),
                by(rule("graph-reachability.pl", clause(9))),
                bindings([binding("Start", e), binding("Goal", g), binding("Visited", [e, c]), binding("Next", f)]),
                uses([
                  proof(
                    goal(edge(e, f)),
                    by(fact("graph-reachability.pl", clause(6)))
                  ),
                  proof(
                    goal('\\+'(member(f, [e, c]))),
                    by(builtin('\\+', 1))
                  ),
                  proof(
                    goal(reachable(f, g, [f, e, c])),
                    by(rule("graph-reachability.pl", clause(9))),
                    bindings([binding("Start", f), binding("Goal", g), binding("Visited", [f, e, c]), binding("Next", g)]),
                    uses([
                      proof(
                        goal(edge(f, g)),
                        by(fact("graph-reachability.pl", clause(7)))
                      ),
                      proof(
                        goal('\\+'(member(g, [f, e, c]))),
                        by(builtin('\\+', 1))
                      ),
                      proof(
                        goal(reachable(g, g, [g, f, e, c])),
                        by(fact("graph-reachability.pl", clause(8))),
                        bindings([binding("Node", g), binding("_visited", [g, f, e, c])])
                      )
                    ])
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

not_reachable(reachability_case, path(b, e)).
why(
  not_reachable(reachability_case, path(b, e)),
  proof(
    goal(not_reachable(reachability_case, path(b, e))),
    by(rule("graph-reachability.pl", clause(13))),
    uses([
      proof(
        goal('\\+'(is_reachable(b, e))),
        by(builtin('\\+', 1))
      )
    ])
  )
).

