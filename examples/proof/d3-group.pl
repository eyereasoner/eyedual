subgroups(d3_group, []).
why(
  subgroups(d3_group, []),
  proof(
    goal(subgroups(d3_group, [])),
    by(rule("d3-group.pl", clause(57))),
    bindings([binding("Groups", [])]),
    uses([
      proof(
        goal(all_subgroups([])),
        by(rule("d3-group.pl", clause(56))),
        bindings([binding("Groups", []), binding("Raw", [])]),
        uses([
          proof(
            goal(findall(G, valid_group(G), [])),
            by(builtin(findall, 3))
          ),
          proof(
            goal(sort([], [])),
            by(library(sort, 2))
          )
        ])
      )
    ])
  )
).

subgroupCount(d3_group, 0).
why(
  subgroupCount(d3_group, 0),
  proof(
    goal(subgroupCount(d3_group, 0)),
    by(rule("d3-group.pl", clause(58))),
    bindings([binding("Count", 0), binding("Groups", [])]),
    uses([
      proof(
        goal(all_subgroups([])),
        by(rule("d3-group.pl", clause(56))),
        bindings([binding("Groups", []), binding("Raw", [])]),
        uses([
          proof(
            goal(findall(G, valid_group(G), [])),
            by(builtin(findall, 3))
          ),
          proof(
            goal(sort([], [])),
            by(library(sort, 2))
          )
        ])
      ),
      proof(
        goal(length([], 0)),
        by(library(length, 2))
      )
    ])
  )
).

