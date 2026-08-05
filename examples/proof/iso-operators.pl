report(parsed_as, [reports, sensor_7, temperature]).
why(
  report(parsed_as, [reports, sensor_7, temperature]),
  proof(
    goal(report(parsed_as, [reports, sensor_7, temperature])),
    by(rule("iso-operators.pl", clause(6))),
    bindings([binding("Parts", [reports, sensor_7, temperature])]),
    uses([
      proof(
        goal('=..'(reports(sensor_7, temperature), [reports, sensor_7, temperature])),
        by(builtin('=..', 2))
      )
    ])
  )
).

report(observations, and(humidity, temperature)).
why(
  report(observations, and(humidity, temperature)),
  proof(
    goal(report(observations, and(humidity, temperature))),
    by(rule("iso-operators.pl", clause(7))),
    bindings([binding("Pair", and(humidity, temperature))]),
    uses([
      proof(
        goal(observations(sensor_7, and(humidity, temperature))),
        by(rule("iso-operators.pl", clause(5))),
        bindings([binding("Sensor", sensor_7), binding("First", humidity), binding("Second", temperature)]),
        uses([
          proof(
            goal(reports(sensor_7, humidity)),
            by(fact("iso-operators.pl", clause(4)))
          ),
          proof(
            goal(reports(sensor_7, temperature)),
            by(fact("iso-operators.pl", clause(3)))
          ),
          proof(
            goal(@<(humidity, temperature)),
            by(builtin(@<, 2))
          )
        ])
      )
    ])
  )
).

report(operator, operator(600, xfx)).
why(
  report(operator, operator(600, xfx)),
  proof(
    goal(report(operator, operator(600, xfx))),
    by(rule("iso-operators.pl", clause(8))),
    bindings([binding("Priority", 600), binding("Specifier", xfx)]),
    uses([
      proof(
        goal(current_op(600, xfx, reports)),
        by(builtin(current_op, 3))
      )
    ])
  )
).

