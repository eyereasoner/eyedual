pressure_Pa(cell1, 100000.0).
why(
  pressure_Pa(cell1, 100000.0),
  proof(
    goal(pressure_Pa(cell1, 100000.0)),
    by(rule("ideal-gas-law.pl", clause(6))),
    bindings([binding("Cell", cell1), binding("Pressure", 100000.0)]),
    uses([
      proof(
        goal(pressure(cell1, 100000.0)),
        by(rule("ideal-gas-law.pl", clause(4))),
        bindings([binding("Cell", cell1), binding("Pressure", 100000.0), binding("Moles", 1.0), binding("Gasconstant", 8.0), binding("Temperature", 300.0), binding("Volume", 0.024), binding("Nr", 8.0), binding("Nrt", 2400.0)]),
        uses([
          proof(
            goal(gas_cell(cell1, 1.0, 8.0, 300.0, 0.024)),
            by(fact("ideal-gas-law.pl", clause(1)))
          ),
          proof(
            goal(is(8.0, *(1.0, 8.0))),
            by(builtin(is, 2))
          ),
          proof(
            goal(is(2400.0, *(8.0, 300.0))),
            by(builtin(is, 2))
          ),
          proof(
            goal(is(100000.0, /(2400.0, 0.024))),
            by(builtin(is, 2))
          )
        ])
      )
    ])
  )
).

status(cell1, near_atmospheric).
why(
  status(cell1, near_atmospheric),
  proof(
    goal(status(cell1, near_atmospheric)),
    by(rule("ideal-gas-law.pl", clause(7))),
    bindings([binding("Cell", cell1)]),
    uses([
      proof(
        goal(near_atmospheric(cell1)),
        by(rule("ideal-gas-law.pl", clause(5))),
        bindings([binding("Cell", cell1), binding("Pressure", 100000.0), binding("Low", 95000.0), binding("High", 105000.0)]),
        uses([
          proof(
            goal(pressure(cell1, 100000.0)),
            by(rule("ideal-gas-law.pl", clause(4))),
            bindings([binding("Cell", cell1), binding("Pressure", 100000.0), binding("Moles", 1.0), binding("Gasconstant", 8.0), binding("Temperature", 300.0), binding("Volume", 0.024), binding("Nr", 8.0), binding("Nrt", 2400.0)]),
            uses([
              proof(
                goal(gas_cell(cell1, 1.0, 8.0, 300.0, 0.024)),
                by(fact("ideal-gas-law.pl", clause(1)))
              ),
              proof(
                goal(is(8.0, *(1.0, 8.0))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(2400.0, *(8.0, 300.0))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(100000.0, /(2400.0, 0.024))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(pressure_limit(cell1, low_Pa, 95000.0)),
            by(fact("ideal-gas-law.pl", clause(2)))
          ),
          proof(
            goal(pressure_limit(cell1, high_Pa, 105000.0)),
            by(fact("ideal-gas-law.pl", clause(3)))
          ),
          proof(
            goal(>(100000.0, 95000.0)),
            by(builtin(>, 2))
          ),
          proof(
            goal(<(100000.0, 105000.0)),
            by(builtin(<, 2))
          )
        ])
      )
    ])
  )
).

reason(cell1, "pressure is inside the one-atmosphere tolerance band").
why(
  reason(cell1, "pressure is inside the one-atmosphere tolerance band"),
  proof(
    goal(reason(cell1, "pressure is inside the one-atmosphere tolerance band")),
    by(rule("ideal-gas-law.pl", clause(8))),
    bindings([binding("Cell", cell1)]),
    uses([
      proof(
        goal(near_atmospheric(cell1)),
        by(rule("ideal-gas-law.pl", clause(5))),
        bindings([binding("Cell", cell1), binding("Pressure", 100000.0), binding("Low", 95000.0), binding("High", 105000.0)]),
        uses([
          proof(
            goal(pressure(cell1, 100000.0)),
            by(rule("ideal-gas-law.pl", clause(4))),
            bindings([binding("Cell", cell1), binding("Pressure", 100000.0), binding("Moles", 1.0), binding("Gasconstant", 8.0), binding("Temperature", 300.0), binding("Volume", 0.024), binding("Nr", 8.0), binding("Nrt", 2400.0)]),
            uses([
              proof(
                goal(gas_cell(cell1, 1.0, 8.0, 300.0, 0.024)),
                by(fact("ideal-gas-law.pl", clause(1)))
              ),
              proof(
                goal(is(8.0, *(1.0, 8.0))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(2400.0, *(8.0, 300.0))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(100000.0, /(2400.0, 0.024))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(pressure_limit(cell1, low_Pa, 95000.0)),
            by(fact("ideal-gas-law.pl", clause(2)))
          ),
          proof(
            goal(pressure_limit(cell1, high_Pa, 105000.0)),
            by(fact("ideal-gas-law.pl", clause(3)))
          ),
          proof(
            goal(>(100000.0, 95000.0)),
            by(builtin(>, 2))
          ),
          proof(
            goal(<(100000.0, 105000.0)),
            by(builtin(<, 2))
          )
        ])
      )
    ])
  )
).

