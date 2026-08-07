metric(bp1, thermal_margin_c, -18.0).
why(
  metric(bp1, thermal_margin_c, -18.0),
  proof(
    goal(metric(bp1, thermal_margin_c, -18.0)),
    by(rule("spacecraft-battery-diagnosis.pl", clause(11))),
    bindings([binding("Pack", bp1), binding("Margin", -18.0), binding("Maximum", 60.0), binding("Temperature", 78.0)]),
    uses([
      proof(
        goal(safety_limit(max_safe_temperature_c, 60.0)),
        by(fact("spacecraft-battery-diagnosis.pl", clause(7)))
      ),
      proof(
        goal(telemetry(bp1, temperature_c, 78.0)),
        by(fact("spacecraft-battery-diagnosis.pl", clause(1)))
      ),
      proof(
        goal(is(-18.0, '-'(60.0, 78.0))),
        by(builtin(is, 2))
      )
    ])
  )
).

metric(bp1, resistive_heating_w, 16.0).
why(
  metric(bp1, resistive_heating_w, 16.0),
  proof(
    goal(metric(bp1, resistive_heating_w, 16.0)),
    by(rule("spacecraft-battery-diagnosis.pl", clause(12))),
    bindings([binding("Pack", bp1), binding("Heating", 16.0), binding("Current", 32.0), binding("Resistance", 0.015625), binding("CurrentSquared", 1024.0)]),
    uses([
      proof(
        goal(telemetry(bp1, current_a, 32.0)),
        by(fact("spacecraft-battery-diagnosis.pl", clause(3)))
      ),
      proof(
        goal(telemetry(bp1, internal_resistance_ohm, 0.015625)),
        by(fact("spacecraft-battery-diagnosis.pl", clause(4)))
      ),
      proof(
        goal(is(1024.0, *(32.0, 32.0))),
        by(builtin(is, 2))
      ),
      proof(
        goal(is(16.0, *(1024.0, 0.015625))),
        by(builtin(is, 2))
      )
    ])
  )
).

diagnosis(bp1, thermal_runaway_precursor).
why(
  diagnosis(bp1, thermal_runaway_precursor),
  proof(
    goal(diagnosis(bp1, thermal_runaway_precursor)),
    by(rule("spacecraft-battery-diagnosis.pl", clause(18))),
    bindings([binding("Pack", bp1)]),
    uses([
      proof(
        goal(over_temperature(bp1)),
        by(rule("spacecraft-battery-diagnosis.pl", clause(13))),
        bindings([binding("Pack", bp1), binding("Temperature", 78.0), binding("Maximum", 60.0)]),
        uses([
          proof(
            goal(telemetry(bp1, temperature_c, 78.0)),
            by(fact("spacecraft-battery-diagnosis.pl", clause(1)))
          ),
          proof(
            goal(safety_limit(max_safe_temperature_c, 60.0)),
            by(fact("spacecraft-battery-diagnosis.pl", clause(7)))
          ),
          proof(
            goal(>(78.0, 60.0)),
            by(builtin(>, 2))
          )
        ])
      ),
      proof(
        goal(rapid_heating(bp1)),
        by(rule("spacecraft-battery-diagnosis.pl", clause(14))),
        bindings([binding("Pack", bp1), binding("Rate", 4.2), binding("Maximum", 1.5)]),
        uses([
          proof(
            goal(telemetry(bp1, temperature_rise_c_per_min, 4.2)),
            by(fact("spacecraft-battery-diagnosis.pl", clause(2)))
          ),
          proof(
            goal(safety_limit(max_temperature_rise_c_per_min, 1.5)),
            by(fact("spacecraft-battery-diagnosis.pl", clause(8)))
          ),
          proof(
            goal(>(4.2, 1.5)),
            by(builtin(>, 2))
          )
        ])
      ),
      proof(
        goal(cell_imbalance(bp1)),
        by(rule("spacecraft-battery-diagnosis.pl", clause(15))),
        bindings([binding("Pack", bp1), binding("Delta", 0.19), binding("Maximum", 0.08)]),
        uses([
          proof(
            goal(telemetry(bp1, cell_delta_v, 0.19)),
            by(fact("spacecraft-battery-diagnosis.pl", clause(5)))
          ),
          proof(
            goal(safety_limit(max_cell_delta_v, 0.08)),
            by(fact("spacecraft-battery-diagnosis.pl", clause(9)))
          ),
          proof(
            goal(>(0.19, 0.08)),
            by(builtin(>, 2))
          )
        ])
      ),
      proof(
        goal(heating_exceeds_cooling(bp1)),
        by(rule("spacecraft-battery-diagnosis.pl", clause(16))),
        bindings([binding("Pack", bp1), binding("Heating", 16.0), binding("Capacity", 12.0)]),
        uses([
          proof(
            goal(metric(bp1, resistive_heating_w, 16.0)),
            by(rule("spacecraft-battery-diagnosis.pl", clause(12))),
            bindings([binding("Pack", bp1), binding("Heating", 16.0), binding("Current", 32.0), binding("Resistance", 0.015625), binding("CurrentSquared", 1024.0)]),
            uses([
              proof(
                goal(telemetry(bp1, current_a, 32.0)),
                by(fact("spacecraft-battery-diagnosis.pl", clause(3)))
              ),
              proof(
                goal(telemetry(bp1, internal_resistance_ohm, 0.015625)),
                by(fact("spacecraft-battery-diagnosis.pl", clause(4)))
              ),
              proof(
                goal(is(1024.0, *(32.0, 32.0))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(16.0, *(1024.0, 0.015625))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(cooling_capacity_w(bp1, 12.0)),
            by(fact("spacecraft-battery-diagnosis.pl", clause(10)))
          ),
          proof(
            goal(>(16.0, 12.0)),
            by(builtin(>, 2))
          )
        ])
      )
    ])
  )
).

action(bp1, isolate_and_cool).
why(
  action(bp1, isolate_and_cool),
  proof(
    goal(action(bp1, isolate_and_cool)),
    by(rule("spacecraft-battery-diagnosis.pl", clause(19))),
    bindings([binding("Pack", bp1)]),
    uses([
      proof(
        goal(diagnosis(bp1, thermal_runaway_precursor)),
        by(rule("spacecraft-battery-diagnosis.pl", clause(18))),
        bindings([binding("Pack", bp1)]),
        uses([
          proof(
            goal(over_temperature(bp1)),
            by(rule("spacecraft-battery-diagnosis.pl", clause(13))),
            bindings([binding("Pack", bp1), binding("Temperature", 78.0), binding("Maximum", 60.0)]),
            uses([
              proof(
                goal(telemetry(bp1, temperature_c, 78.0)),
                by(fact("spacecraft-battery-diagnosis.pl", clause(1)))
              ),
              proof(
                goal(safety_limit(max_safe_temperature_c, 60.0)),
                by(fact("spacecraft-battery-diagnosis.pl", clause(7)))
              ),
              proof(
                goal(>(78.0, 60.0)),
                by(builtin(>, 2))
              )
            ])
          ),
          proof(
            goal(rapid_heating(bp1)),
            by(rule("spacecraft-battery-diagnosis.pl", clause(14))),
            bindings([binding("Pack", bp1), binding("Rate", 4.2), binding("Maximum", 1.5)]),
            uses([
              proof(
                goal(telemetry(bp1, temperature_rise_c_per_min, 4.2)),
                by(fact("spacecraft-battery-diagnosis.pl", clause(2)))
              ),
              proof(
                goal(safety_limit(max_temperature_rise_c_per_min, 1.5)),
                by(fact("spacecraft-battery-diagnosis.pl", clause(8)))
              ),
              proof(
                goal(>(4.2, 1.5)),
                by(builtin(>, 2))
              )
            ])
          ),
          proof(
            goal(cell_imbalance(bp1)),
            by(rule("spacecraft-battery-diagnosis.pl", clause(15))),
            bindings([binding("Pack", bp1), binding("Delta", 0.19), binding("Maximum", 0.08)]),
            uses([
              proof(
                goal(telemetry(bp1, cell_delta_v, 0.19)),
                by(fact("spacecraft-battery-diagnosis.pl", clause(5)))
              ),
              proof(
                goal(safety_limit(max_cell_delta_v, 0.08)),
                by(fact("spacecraft-battery-diagnosis.pl", clause(9)))
              ),
              proof(
                goal(>(0.19, 0.08)),
                by(builtin(>, 2))
              )
            ])
          ),
          proof(
            goal(heating_exceeds_cooling(bp1)),
            by(rule("spacecraft-battery-diagnosis.pl", clause(16))),
            bindings([binding("Pack", bp1), binding("Heating", 16.0), binding("Capacity", 12.0)]),
            uses([
              proof(
                goal(metric(bp1, resistive_heating_w, 16.0)),
                by(rule("spacecraft-battery-diagnosis.pl", clause(12))),
                bindings([binding("Pack", bp1), binding("Heating", 16.0), binding("Current", 32.0), binding("Resistance", 0.015625), binding("CurrentSquared", 1024.0)]),
                uses([
                  proof(
                    goal(telemetry(bp1, current_a, 32.0)),
                    by(fact("spacecraft-battery-diagnosis.pl", clause(3)))
                  ),
                  proof(
                    goal(telemetry(bp1, internal_resistance_ohm, 0.015625)),
                    by(fact("spacecraft-battery-diagnosis.pl", clause(4)))
                  ),
                  proof(
                    goal(is(1024.0, *(32.0, 32.0))),
                    by(builtin(is, 2))
                  ),
                  proof(
                    goal(is(16.0, *(1024.0, 0.015625))),
                    by(builtin(is, 2))
                  )
                ])
              ),
              proof(
                goal(cooling_capacity_w(bp1, 12.0)),
                by(fact("spacecraft-battery-diagnosis.pl", clause(10)))
              ),
              proof(
                goal(>(16.0, 12.0)),
                by(builtin(>, 2))
              )
            ])
          )
        ])
      ),
      proof(
        goal(corroborated_over_temperature(bp1)),
        by(rule("spacecraft-battery-diagnosis.pl", clause(17))),
        bindings([binding("Pack", bp1), binding("Primary", 78.0), binding("Redundant", 76.0), binding("Maximum", 60.0)]),
        uses([
          proof(
            goal(telemetry(bp1, temperature_c, 78.0)),
            by(fact("spacecraft-battery-diagnosis.pl", clause(1)))
          ),
          proof(
            goal(redundant_telemetry(bp1, temperature_c, 76.0)),
            by(fact("spacecraft-battery-diagnosis.pl", clause(6)))
          ),
          proof(
            goal(safety_limit(max_safe_temperature_c, 60.0)),
            by(fact("spacecraft-battery-diagnosis.pl", clause(7)))
          ),
          proof(
            goal(>(78.0, 60.0)),
            by(builtin(>, 2))
          ),
          proof(
            goal(>(76.0, 60.0)),
            by(builtin(>, 2))
          )
        ])
      )
    ])
  )
).

