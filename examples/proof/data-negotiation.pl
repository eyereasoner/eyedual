negotiate(agent1, [agent2, data4]).
why(
  negotiate(agent1, [agent2, data4]),
  proof(
    goal(negotiate(agent1, [agent2, data4])),
    by(rule("data-negotiation.pl", clause(10))),
    bindings([binding("Agenta", agent1), binding("Agentb", agent2), binding("Data", data4)]),
    uses([
      proof(
        goal(want_negotiate(agent1, [agent2, data4])),
        by(fact("data-negotiation.pl", clause(3)))
      ),
      proof(
        goal(request_data(agent1, agent2, data4)),
        by(rule("data-negotiation.pl", clause(8))),
        bindings([binding("Agenta", agent1), binding("Agentb", agent2), binding("Data", data4), binding("Datalista", [data1, data2, data3]), binding("Datalistb", [data4, data5, data6])]),
        uses([
          proof(
            goal(hasData(agent1, [data1, data2, data3])),
            by(fact("data-negotiation.pl", clause(1)))
          ),
          proof(
            goal(hasData(agent2, [data4, data5, data6])),
            by(fact("data-negotiation.pl", clause(2)))
          ),
          proof(
            goal(member(data4, [data4, data5, data6])),
            by(library(member, 2))
          ),
          proof(
            goal('\\+'(member(data4, [data1, data2, data3]))),
            by(builtin('\\+', 1))
          ),
          proof(
            goal(policy(agent1, [request, data4])),
            by(rule("data-negotiation.pl", clause(6))),
            bindings([binding("Data", data4)]),
            uses([
              proof(
                goal(member(data4, [data4, data6])),
                by(library(member, 2))
              )
            ])
          )
        ])
      ),
      proof(
        goal(accept_request(agent2, agent1, data4)),
        by(rule("data-negotiation.pl", clause(9))),
        bindings([binding("Agentb", agent2), binding("_agenta", agent1), binding("Data", data4), binding("Datalistb", [data4, data5, data6])]),
        uses([
          proof(
            goal(hasData(agent2, [data4, data5, data6])),
            by(fact("data-negotiation.pl", clause(2)))
          ),
          proof(
            goal(member(data4, [data4, data5, data6])),
            by(library(member, 2))
          ),
          proof(
            goal(policy(agent2, [accept, data4])),
            by(rule("data-negotiation.pl", clause(7))),
            bindings([binding("Data", data4)]),
            uses([
              proof(
                goal(\=(data4, data5)),
                by(builtin(\=, 2))
              )
            ])
          )
        ])
      )
    ])
  )
).

