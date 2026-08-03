type(beam1, cantilever_beam).
why(
  type(beam1, cantilever_beam),
  proof(
    goal(type(beam1, cantilever_beam)),
    by(rule("beam-deflection.pl", clause(8))),
    bindings([binding("Beam", beam1), binding("_force", 1200.0)]),
    uses([
      proof(
        goal(beam(beam1, force_N, 1200.0)),
        by(fact("beam-deflection.pl", clause(1)))
      )
    ])
  )
).

tipDeflection_m(beam1, 0.00390625).
why(
  tipDeflection_m(beam1, 0.00390625),
  proof(
    goal(tipDeflection_m(beam1, 0.00390625)),
    by(rule("beam-deflection.pl", clause(9))),
    bindings([binding("Beam", beam1), binding("Deflectionm", 0.00390625)]),
    uses([
      proof(
        goal(tip_deflection_m(beam1, 0.00390625)),
        by(rule("beam-deflection.pl", clause(6))),
        bindings([binding("Beam", beam1), binding("Deflection", 0.00390625), binding("Force", 1200.0), binding("Length", 2.5), binding("Elasticmodulus", 200000000000.0), binding("Secondmoment", 0.000008), binding("Lengthcubed", 15.625), binding("Numerator", 18750.0), binding("Threee", 600000000000.0), binding("Denominator", 4800000.0)]),
        uses([
          proof(
            goal(beam(beam1, force_N, 1200.0)),
            by(fact("beam-deflection.pl", clause(1)))
          ),
          proof(
            goal(beam(beam1, length_m, 2.5)),
            by(fact("beam-deflection.pl", clause(2)))
          ),
          proof(
            goal(beam(beam1, elasticModulus_Pa, 200000000000.0)),
            by(fact("beam-deflection.pl", clause(3)))
          ),
          proof(
            goal(beam(beam1, secondMoment_m4, 0.000008)),
            by(fact("beam-deflection.pl", clause(4)))
          ),
          proof(
            goal(is(15.625, **(2.5, 3.0))),
            by(builtin(is, 2))
          ),
          proof(
            goal(is(18750.0, *(1200.0, 15.625))),
            by(builtin(is, 2))
          ),
          proof(
            goal(is(600000000000.0, *(3.0, 200000000000.0))),
            by(builtin(is, 2))
          ),
          proof(
            goal(is(4800000.0, *(600000000000.0, 0.000008))),
            by(builtin(is, 2))
          ),
          proof(
            goal(is(0.00390625, /(18750.0, 4800000.0))),
            by(builtin(is, 2))
          )
        ])
      )
    ])
  )
).

tipDeflection_mm(beam1, 3.90625).
why(
  tipDeflection_mm(beam1, 3.90625),
  proof(
    goal(tipDeflection_mm(beam1, 3.90625)),
    by(rule("beam-deflection.pl", clause(10))),
    bindings([binding("Beam", beam1), binding("Deflectionmm", 3.90625)]),
    uses([
      proof(
        goal(tip_deflection_mm(beam1, 3.90625)),
        by(rule("beam-deflection.pl", clause(7))),
        bindings([binding("Beam", beam1), binding("Deflectionmm", 3.90625), binding("Deflectionm", 0.00390625)]),
        uses([
          proof(
            goal(tip_deflection_m(beam1, 0.00390625)),
            by(rule("beam-deflection.pl", clause(6))),
            bindings([binding("Beam", beam1), binding("Deflection", 0.00390625), binding("Force", 1200.0), binding("Length", 2.5), binding("Elasticmodulus", 200000000000.0), binding("Secondmoment", 0.000008), binding("Lengthcubed", 15.625), binding("Numerator", 18750.0), binding("Threee", 600000000000.0), binding("Denominator", 4800000.0)]),
            uses([
              proof(
                goal(beam(beam1, force_N, 1200.0)),
                by(fact("beam-deflection.pl", clause(1)))
              ),
              proof(
                goal(beam(beam1, length_m, 2.5)),
                by(fact("beam-deflection.pl", clause(2)))
              ),
              proof(
                goal(beam(beam1, elasticModulus_Pa, 200000000000.0)),
                by(fact("beam-deflection.pl", clause(3)))
              ),
              proof(
                goal(beam(beam1, secondMoment_m4, 0.000008)),
                by(fact("beam-deflection.pl", clause(4)))
              ),
              proof(
                goal(is(15.625, **(2.5, 3.0))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(18750.0, *(1200.0, 15.625))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(600000000000.0, *(3.0, 200000000000.0))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(4800000.0, *(600000000000.0, 0.000008))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(0.00390625, /(18750.0, 4800000.0))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(is(3.90625, *(0.00390625, 1000.0))),
            by(builtin(is, 2))
          )
        ])
      )
    ])
  )
).

limit_mm(beam1, 5.0).
why(
  limit_mm(beam1, 5.0),
  proof(
    goal(limit_mm(beam1, 5.0)),
    by(rule("beam-deflection.pl", clause(11))),
    bindings([binding("Beam", beam1), binding("Limit", 5.0)]),
    uses([
      proof(
        goal(limit(beam1, maxDeflection_mm, 5.0)),
        by(fact("beam-deflection.pl", clause(5)))
      )
    ])
  )
).

status(beam1, within_deflection_limit).
why(
  status(beam1, within_deflection_limit),
  proof(
    goal(status(beam1, within_deflection_limit)),
    by(rule("beam-deflection.pl", clause(12))),
    bindings([binding("Beam", beam1), binding("Deflectionmm", 3.90625), binding("Limit", 5.0)]),
    uses([
      proof(
        goal(tip_deflection_mm(beam1, 3.90625)),
        by(rule("beam-deflection.pl", clause(7))),
        bindings([binding("Beam", beam1), binding("Deflectionmm", 3.90625), binding("Deflectionm", 0.00390625)]),
        uses([
          proof(
            goal(tip_deflection_m(beam1, 0.00390625)),
            by(rule("beam-deflection.pl", clause(6))),
            bindings([binding("Beam", beam1), binding("Deflection", 0.00390625), binding("Force", 1200.0), binding("Length", 2.5), binding("Elasticmodulus", 200000000000.0), binding("Secondmoment", 0.000008), binding("Lengthcubed", 15.625), binding("Numerator", 18750.0), binding("Threee", 600000000000.0), binding("Denominator", 4800000.0)]),
            uses([
              proof(
                goal(beam(beam1, force_N, 1200.0)),
                by(fact("beam-deflection.pl", clause(1)))
              ),
              proof(
                goal(beam(beam1, length_m, 2.5)),
                by(fact("beam-deflection.pl", clause(2)))
              ),
              proof(
                goal(beam(beam1, elasticModulus_Pa, 200000000000.0)),
                by(fact("beam-deflection.pl", clause(3)))
              ),
              proof(
                goal(beam(beam1, secondMoment_m4, 0.000008)),
                by(fact("beam-deflection.pl", clause(4)))
              ),
              proof(
                goal(is(15.625, **(2.5, 3.0))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(18750.0, *(1200.0, 15.625))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(600000000000.0, *(3.0, 200000000000.0))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(4800000.0, *(600000000000.0, 0.000008))),
                by(builtin(is, 2))
              ),
              proof(
                goal(is(0.00390625, /(18750.0, 4800000.0))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(is(3.90625, *(0.00390625, 1000.0))),
            by(builtin(is, 2))
          )
        ])
      ),
      proof(
        goal(limit(beam1, maxDeflection_mm, 5.0)),
        by(fact("beam-deflection.pl", clause(5)))
      ),
      proof(
        goal(=<(3.90625, 5.0)),
        by(builtin(=<, 2))
      )
    ])
  )
).

