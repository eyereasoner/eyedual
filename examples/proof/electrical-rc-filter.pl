type(filter1, first_order_low_pass).
why(
  type(filter1, first_order_low_pass),
  proof(
    goal(type(filter1, first_order_low_pass)),
    by(rule("electrical-rc-filter.pl", clause(6))),
    bindings([binding("Filter", filter1), binding("_r", 10000.0), binding("_c", 0.000001)]),
    uses([
      proof(
        goal(component(filter1, resistor_ohm, 10000.0)),
        by(fact("electrical-rc-filter.pl", clause(1)))
      ),
      proof(
        goal(component(filter1, capacitor_f, 0.000001)),
        by(fact("electrical-rc-filter.pl", clause(2)))
      )
    ])
  )
).

timeConstant_s(filter1, 0.01).
why(
  timeConstant_s(filter1, 0.01),
  proof(
    goal(timeConstant_s(filter1, 0.01)),
    by(rule("electrical-rc-filter.pl", clause(7))),
    bindings([binding("Filter", filter1), binding("Tau", 0.01)]),
    uses([
      proof(
        goal(time_constant(filter1, 0.01)),
        by(rule("electrical-rc-filter.pl", clause(4))),
        bindings([binding("Filter", filter1), binding("Tau", 0.01), binding("R", 10000.0), binding("C", 0.000001)]),
        uses([
          proof(
            goal(component(filter1, resistor_ohm, 10000.0)),
            by(fact("electrical-rc-filter.pl", clause(1)))
          ),
          proof(
            goal(component(filter1, capacitor_f, 0.000001)),
            by(fact("electrical-rc-filter.pl", clause(2)))
          ),
          proof(
            goal(is(0.01, *(10000.0, 0.000001))),
            by(builtin(is, 2))
          )
        ])
      )
    ])
  )
).

cutoffFrequency_Hz(filter1, 15.915494309189533).
why(
  cutoffFrequency_Hz(filter1, 15.915494309189533),
  proof(
    goal(cutoffFrequency_Hz(filter1, 15.915494309189533)),
    by(rule("electrical-rc-filter.pl", clause(8))),
    bindings([binding("Filter", filter1), binding("Frequency", 15.915494309189533)]),
    uses([
      proof(
        goal(cutoff_frequency(filter1, 15.915494309189533)),
        by(rule("electrical-rc-filter.pl", clause(5))),
        bindings([binding("Filter", filter1), binding("Frequency", 15.915494309189533), binding("Tau", 0.01), binding("Pi", 3.141592653589793), binding("Twopi", 6.2831853071795862), binding("Denominator", 0.062831853071795868)]),
        uses([
          proof(
            goal(time_constant(filter1, 0.01)),
            by(rule("electrical-rc-filter.pl", clause(4))),
            bindings([binding("Filter", filter1), binding("Tau", 0.01), binding("R", 10000.0), binding("C", 0.000001)]),
            uses([
              proof(
                goal(component(filter1, resistor_ohm, 10000.0)),
                by(fact("electrical-rc-filter.pl", clause(1)))
              ),
              proof(
                goal(component(filter1, capacitor_f, 0.000001)),
                by(fact("electrical-rc-filter.pl", clause(2)))
              ),
              proof(
                goal(is(0.01, *(10000.0, 0.000001))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(constant(pi, 3.141592653589793)),
            by(fact("electrical-rc-filter.pl", clause(3)))
          ),
          proof(
            goal(is(6.2831853071795862, *(2.0, 3.141592653589793))),
            by(builtin(is, 2))
          ),
          proof(
            goal(is(0.062831853071795868, *(6.2831853071795862, 0.01))),
            by(builtin(is, 2))
          ),
          proof(
            goal(is(15.915494309189533, /(1.0, 0.062831853071795868))),
            by(builtin(is, 2))
          )
        ])
      )
    ])
  )
).

