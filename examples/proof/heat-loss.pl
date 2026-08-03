type(wall1, conduction_heat_loss).
why(
  type(wall1, conduction_heat_loss),
  proof(
    goal(type(wall1, conduction_heat_loss)),
    by(rule("heat-loss.pl", clause(9))),
    bindings([binding("Wall", wall1), binding("_thickness", 0.2)]),
    uses([
      proof(
        goal(wall(wall1, thickness_m, 0.2)),
        by(fact("heat-loss.pl", clause(3)))
      )
    ])
  )
).

temperatureDifference_K(wall1, 25.0).
why(
  temperatureDifference_K(wall1, 25.0),
  proof(
    goal(temperatureDifference_K(wall1, 25.0)),
    by(rule("heat-loss.pl", clause(10))),
    bindings([binding("Wall", wall1), binding("Deltat", 25.0)]),
    uses([
      proof(
        goal(temperature_difference(wall1, 25.0)),
        by(rule("heat-loss.pl", clause(6))),
        bindings([binding("Wall", wall1), binding("Deltat", 25.0), binding("Indoor", 21.0), binding("Outdoor", -4.0)]),
        uses([
          proof(
            goal(wall(wall1, indoor_C, 21.0)),
            by(fact("heat-loss.pl", clause(4)))
          ),
          proof(
            goal(wall(wall1, outdoor_C, -4.0)),
            by(fact("heat-loss.pl", clause(5)))
          ),
          proof(
            goal(is(25.0, '-'(21.0, -4.0))),
            by(builtin(is, 2))
          )
        ])
      )
    ])
  )
).

thermalResistance_K_W(wall1, 0.020833333333333332).
why(
  thermalResistance_K_W(wall1, 0.020833333333333332),
  proof(
    goal(thermalResistance_K_W(wall1, 0.020833333333333332)),
    by(rule("heat-loss.pl", clause(11))),
    bindings([binding("Wall", wall1), binding("Resistance", 0.020833333333333332)]),
    uses([
      proof(
        goal(thermal_resistance(wall1, 0.020833333333333332)),
        by(rule("heat-loss.pl", clause(7))),
        bindings([binding("Wall", wall1), binding("Resistance", 0.020833333333333332), binding("Thickness", 0.2), binding("Conductivity", 0.8), binding("Area", 12.0), binding("Conductance", 9.6000000000000014)]),
        uses([
          proof(
            goal(wall(wall1, thickness_m, 0.2)),
            by(fact("heat-loss.pl", clause(3)))
          ),
          proof(
            goal(wall(wall1, conductivity_W_mK, 0.8)),
            by(fact("heat-loss.pl", clause(1)))
          ),
          proof(
            goal(wall(wall1, area_m2, 12.0)),
            by(fact("heat-loss.pl", clause(2)))
          ),
          proof(
            goal(is(9.6000000000000014, *(0.8, 12.0))),
            by(builtin(is, 2))
          ),
          proof(
            goal(is(0.020833333333333332, /(0.2, 9.6000000000000014))),
            by(builtin(is, 2))
          )
        ])
      )
    ])
  )
).

heatLoss_W(wall1, 1200.0).
why(
  heatLoss_W(wall1, 1200.0),
  proof(
    goal(heatLoss_W(wall1, 1200.0)),
    by(rule("heat-loss.pl", clause(12))),
    bindings([binding("Wall", wall1), binding("Heatloss", 1200.0)]),
    uses([
      proof(
        goal(heat_loss(wall1, 1200.0)),
        by(rule("heat-loss.pl", clause(8))),
        bindings([binding("Wall", wall1), binding("Heatloss", 1200.0), binding("Deltat", 25.0), binding("Resistance", 0.020833333333333332)]),
        uses([
          proof(
            goal(temperature_difference(wall1, 25.0)),
            by(rule("heat-loss.pl", clause(6))),
            bindings([binding("Wall", wall1), binding("Deltat", 25.0), binding("Indoor", 21.0), binding("Outdoor", -4.0)]),
            uses([
              proof(
                goal(wall(wall1, indoor_C, 21.0)),
                by(fact("heat-loss.pl", clause(4)))
              ),
              proof(
                goal(wall(wall1, outdoor_C, -4.0)),
                by(fact("heat-loss.pl", clause(5)))
              ),
              proof(
                goal(is(25.0, '-'(21.0, -4.0))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(thermal_resistance(wall1, 0.020833333333333332)),
            by(rule("heat-loss.pl", clause(7))),
            bindings([binding("Wall", wall1), binding("Resistance", 0.020833333333333332), binding("Thickness", 0.2), binding("Conductivity", 0.8), binding("Area", 12.0), binding("Conductance", 9.6000000000000014)]),
            uses([
              proof(
                goal(wall(wall1, thickness_m, 0.2)),
                by(fact("heat-loss.pl", clause(3)))
              ),
              proof(
                goal(wall(wall1, conductivity_W_mK, 0.8)),
                by(fact("heat-loss.pl", clause(1)))
              ),
              proof(
                goal(wall(wall1, area_m2, 12.0)),
                by(fact("heat-loss.pl", clause(2)))
              ),
              proof(
                goal(is(9.6000000000000014, *(0.8, 12.0))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(0.020833333333333332, /(0.2, 9.6000000000000014))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(is(1200.0, /(25.0, 0.020833333333333332))),
            by(builtin(is, 2))
          )
        ])
      )
    ])
  )
).

status(wall1, high_heat_loss).
why(
  status(wall1, high_heat_loss),
  proof(
    goal(status(wall1, high_heat_loss)),
    by(rule("heat-loss.pl", clause(13))),
    bindings([binding("Wall", wall1), binding("Heatloss", 1200.0)]),
    uses([
      proof(
        goal(heat_loss(wall1, 1200.0)),
        by(rule("heat-loss.pl", clause(8))),
        bindings([binding("Wall", wall1), binding("Heatloss", 1200.0), binding("Deltat", 25.0), binding("Resistance", 0.020833333333333332)]),
        uses([
          proof(
            goal(temperature_difference(wall1, 25.0)),
            by(rule("heat-loss.pl", clause(6))),
            bindings([binding("Wall", wall1), binding("Deltat", 25.0), binding("Indoor", 21.0), binding("Outdoor", -4.0)]),
            uses([
              proof(
                goal(wall(wall1, indoor_C, 21.0)),
                by(fact("heat-loss.pl", clause(4)))
              ),
              proof(
                goal(wall(wall1, outdoor_C, -4.0)),
                by(fact("heat-loss.pl", clause(5)))
              ),
              proof(
                goal(is(25.0, '-'(21.0, -4.0))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(thermal_resistance(wall1, 0.020833333333333332)),
            by(rule("heat-loss.pl", clause(7))),
            bindings([binding("Wall", wall1), binding("Resistance", 0.020833333333333332), binding("Thickness", 0.2), binding("Conductivity", 0.8), binding("Area", 12.0), binding("Conductance", 9.6000000000000014)]),
            uses([
              proof(
                goal(wall(wall1, thickness_m, 0.2)),
                by(fact("heat-loss.pl", clause(3)))
              ),
              proof(
                goal(wall(wall1, conductivity_W_mK, 0.8)),
                by(fact("heat-loss.pl", clause(1)))
              ),
              proof(
                goal(wall(wall1, area_m2, 12.0)),
                by(fact("heat-loss.pl", clause(2)))
              ),
              proof(
                goal(is(9.6000000000000014, *(0.8, 12.0))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(0.020833333333333332, /(0.2, 9.6000000000000014))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(is(1200.0, /(25.0, 0.020833333333333332))),
            by(builtin(is, 2))
          )
        ])
      ),
      proof(
        goal(>(1200.0, 1000.0)),
        by(builtin(>, 2))
      )
    ])
  )
).

