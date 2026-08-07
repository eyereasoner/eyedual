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
            goal(reachable(a, f, "a")),
            by(rule("graph-reachability.pl", clause(9))),
            bindings([binding("Start", a), binding("Goal", f), binding("Visited", "a"), binding("Next", b)]),
            uses([
              proof(
                goal(edge(a, b)),
                by(fact("graph-reachability.pl", clause(1)))
              ),
              proof(
                goal('\\+'(member(b, "a"))),
                by(builtin('\\+', 1))
              ),
              proof(
                goal(reachable(b, f, "ba")),
                by(rule("graph-reachability.pl", clause(9))),
                bindings([binding("Start", b), binding("Goal", f), binding("Visited", "ba"), binding("Next", d)]),
                uses([
                  proof(
                    goal(edge(b, d)),
                    by(fact("graph-reachability.pl", clause(3)))
                  ),
                  proof(
                    goal('\\+'(member(d, "ba"))),
                    by(builtin('\\+', 1))
                  ),
                  proof(
                    goal(reachable(d, f, "dba")),
                    by(rule("graph-reachability.pl", clause(9))),
                    bindings([binding("Start", d), binding("Goal", f), binding("Visited", "dba"), binding("Next", f)]),
                    uses([
                      proof(
                        goal(edge(d, f)),
                        by(fact("graph-reachability.pl", clause(5)))
                      ),
                      proof(
                        goal('\\+'(member(f, "dba"))),
                        by(builtin('\\+', 1))
                      ),
                      proof(
                        goal(reachable(f, f, "fdba")),
                        by(fact("graph-reachability.pl", clause(8))),
                        bindings([binding("Node", f), binding("_visited", "fdba")])
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
            goal(reachable(c, g, "c")),
            by(rule("graph-reachability.pl", clause(9))),
            bindings([binding("Start", c), binding("Goal", g), binding("Visited", "c"), binding("Next", e)]),
            uses([
              proof(
                goal(edge(c, e)),
                by(fact("graph-reachability.pl", clause(4)))
              ),
              proof(
                goal('\\+'(member(e, "c"))),
                by(builtin('\\+', 1))
              ),
              proof(
                goal(reachable(e, g, "ec")),
                by(rule("graph-reachability.pl", clause(9))),
                bindings([binding("Start", e), binding("Goal", g), binding("Visited", "ec"), binding("Next", f)]),
                uses([
                  proof(
                    goal(edge(e, f)),
                    by(fact("graph-reachability.pl", clause(6)))
                  ),
                  proof(
                    goal('\\+'(member(f, "ec"))),
                    by(builtin('\\+', 1))
                  ),
                  proof(
                    goal(reachable(f, g, "fec")),
                    by(rule("graph-reachability.pl", clause(9))),
                    bindings([binding("Start", f), binding("Goal", g), binding("Visited", "fec"), binding("Next", g)]),
                    uses([
                      proof(
                        goal(edge(f, g)),
                        by(fact("graph-reachability.pl", clause(7)))
                      ),
                      proof(
                        goal('\\+'(member(g, "fec"))),
                        by(builtin('\\+', 1))
                      ),
                      proof(
                        goal(reachable(g, g, "gfec")),
                        by(fact("graph-reachability.pl", clause(8))),
                        bindings([binding("Node", g), binding("_visited", "gfec")])
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

