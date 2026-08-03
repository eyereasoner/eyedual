type(p001, trial_candidate).
why(
  type(p001, trial_candidate),
  proof(
    goal(type(p001, trial_candidate)),
    by(rule("clinical-trial-screening.pl", clause(31))),
    bindings([binding("Patient", p001)]),
    uses([
      proof(
        goal(screen_eligible(p001)),
        by(rule("clinical-trial-screening.pl", clause(27))),
        bindings([binding("Patient", p001)]),
        uses([
          proof(
            goal(inclusion_adult(p001)),
            by(rule("clinical-trial-screening.pl", clause(22))),
            bindings([binding("Patient", p001), binding("Age", 54)]),
            uses([
              proof(
                goal(patient(p001)),
                by(fact("clinical-trial-screening.pl", clause(1)))
              ),
              proof(
                goal(age(p001, 54)),
                by(fact("clinical-trial-screening.pl", clause(5)))
              ),
              proof(
                goal(>=(54, 18)),
                by(builtin(>=, 2))
              )
            ])
          ),
          proof(
            goal(inclusion_diagnosis(p001)),
            by(rule("clinical-trial-screening.pl", clause(23))),
            bindings([binding("Patient", p001)]),
            uses([
              proof(
                goal(diagnosis(p001, type2_diabetes)),
                by(fact("clinical-trial-screening.pl", clause(9)))
              )
            ])
          ),
          proof(
            goal(inclusion_hba1c(p001)),
            by(rule("clinical-trial-screening.pl", clause(24))),
            bindings([binding("Patient", p001), binding("Hba1c", 8.4)]),
            uses([
              proof(
                goal(lab(p001, hba1c_pct, 8.4)),
                by(fact("clinical-trial-screening.pl", clause(13)))
              ),
              proof(
                goal(>=(8.4, 7.0)),
                by(builtin(>=, 2))
              ),
              proof(
                goal(=<(8.4, 10.5)),
                by(builtin(=<, 2))
              )
            ])
          ),
          proof(
            goal('\\+'(exclusion_renal(p001))),
            by(builtin('\\+', 1))
          ),
          proof(
            goal('\\+'(exclusion_pregnancy(p001))),
            by(builtin('\\+', 1))
          )
        ])
      )
    ])
  )
).

status(p001, eligible).
why(
  status(p001, eligible),
  proof(
    goal(status(p001, eligible)),
    by(rule("clinical-trial-screening.pl", clause(32))),
    bindings([binding("Patient", p001)]),
    uses([
      proof(
        goal(screen_eligible(p001)),
        by(rule("clinical-trial-screening.pl", clause(27))),
        bindings([binding("Patient", p001)]),
        uses([
          proof(
            goal(inclusion_adult(p001)),
            by(rule("clinical-trial-screening.pl", clause(22))),
            bindings([binding("Patient", p001), binding("Age", 54)]),
            uses([
              proof(
                goal(patient(p001)),
                by(fact("clinical-trial-screening.pl", clause(1)))
              ),
              proof(
                goal(age(p001, 54)),
                by(fact("clinical-trial-screening.pl", clause(5)))
              ),
              proof(
                goal(>=(54, 18)),
                by(builtin(>=, 2))
              )
            ])
          ),
          proof(
            goal(inclusion_diagnosis(p001)),
            by(rule("clinical-trial-screening.pl", clause(23))),
            bindings([binding("Patient", p001)]),
            uses([
              proof(
                goal(diagnosis(p001, type2_diabetes)),
                by(fact("clinical-trial-screening.pl", clause(9)))
              )
            ])
          ),
          proof(
            goal(inclusion_hba1c(p001)),
            by(rule("clinical-trial-screening.pl", clause(24))),
            bindings([binding("Patient", p001), binding("Hba1c", 8.4)]),
            uses([
              proof(
                goal(lab(p001, hba1c_pct, 8.4)),
                by(fact("clinical-trial-screening.pl", clause(13)))
              ),
              proof(
                goal(>=(8.4, 7.0)),
                by(builtin(>=, 2))
              ),
              proof(
                goal(=<(8.4, 10.5)),
                by(builtin(=<, 2))
              )
            ])
          ),
          proof(
            goal('\\+'(exclusion_renal(p001))),
            by(builtin('\\+', 1))
          ),
          proof(
            goal('\\+'(exclusion_pregnancy(p001))),
            by(builtin('\\+', 1))
          )
        ])
      )
    ])
  )
).

status(p002, screen_fail).
why(
  status(p002, screen_fail),
  proof(
    goal(status(p002, screen_fail)),
    by(rule("clinical-trial-screening.pl", clause(34))),
    bindings([binding("Patient", p002)]),
    uses([
      proof(
        goal(screen_fail(p002)),
        by(rule("clinical-trial-screening.pl", clause(28))),
        bindings([binding("Patient", p002)]),
        uses([
          proof(
            goal(exclusion_renal(p002)),
            by(rule("clinical-trial-screening.pl", clause(25))),
            bindings([binding("Patient", p002), binding("Egfr", 38.0)]),
            uses([
              proof(
                goal(lab(p002, egfr_ml_min, 38.0)),
                by(fact("clinical-trial-screening.pl", clause(18)))
              ),
              proof(
                goal(<(38.0, 45.0)),
                by(builtin(<, 2))
              )
            ])
          )
        ])
      )
    ])
  )
).

status(p003, screen_fail).
why(
  status(p003, screen_fail),
  proof(
    goal(status(p003, screen_fail)),
    by(rule("clinical-trial-screening.pl", clause(34))),
    bindings([binding("Patient", p003)]),
    uses([
      proof(
        goal(screen_fail(p003)),
        by(rule("clinical-trial-screening.pl", clause(29))),
        bindings([binding("Patient", p003)]),
        uses([
          proof(
            goal(exclusion_pregnancy(p003)),
            by(rule("clinical-trial-screening.pl", clause(26))),
            bindings([binding("Patient", p003)]),
            uses([
              proof(
                goal(condition(p003, pregnant)),
                by(fact("clinical-trial-screening.pl", clause(21)))
              )
            ])
          )
        ])
      )
    ])
  )
).

status(p004, screen_fail).
why(
  status(p004, screen_fail),
  proof(
    goal(status(p004, screen_fail)),
    by(rule("clinical-trial-screening.pl", clause(34))),
    bindings([binding("Patient", p004)]),
    uses([
      proof(
        goal(screen_fail(p004)),
        by(rule("clinical-trial-screening.pl", clause(30))),
        bindings([binding("Patient", p004)]),
        uses([
          proof(
            goal(patient(p004)),
            by(fact("clinical-trial-screening.pl", clause(4)))
          ),
          proof(
            goal('\\+'(inclusion_hba1c(p004))),
            by(builtin('\\+', 1))
          )
        ])
      )
    ])
  )
).

reason(p001, "meets inclusion criteria and no listed exclusion").
why(
  reason(p001, "meets inclusion criteria and no listed exclusion"),
  proof(
    goal(reason(p001, "meets inclusion criteria and no listed exclusion")),
    by(rule("clinical-trial-screening.pl", clause(33))),
    bindings([binding("Patient", p001)]),
    uses([
      proof(
        goal(screen_eligible(p001)),
        by(rule("clinical-trial-screening.pl", clause(27))),
        bindings([binding("Patient", p001)]),
        uses([
          proof(
            goal(inclusion_adult(p001)),
            by(rule("clinical-trial-screening.pl", clause(22))),
            bindings([binding("Patient", p001), binding("Age", 54)]),
            uses([
              proof(
                goal(patient(p001)),
                by(fact("clinical-trial-screening.pl", clause(1)))
              ),
              proof(
                goal(age(p001, 54)),
                by(fact("clinical-trial-screening.pl", clause(5)))
              ),
              proof(
                goal(>=(54, 18)),
                by(builtin(>=, 2))
              )
            ])
          ),
          proof(
            goal(inclusion_diagnosis(p001)),
            by(rule("clinical-trial-screening.pl", clause(23))),
            bindings([binding("Patient", p001)]),
            uses([
              proof(
                goal(diagnosis(p001, type2_diabetes)),
                by(fact("clinical-trial-screening.pl", clause(9)))
              )
            ])
          ),
          proof(
            goal(inclusion_hba1c(p001)),
            by(rule("clinical-trial-screening.pl", clause(24))),
            bindings([binding("Patient", p001), binding("Hba1c", 8.4)]),
            uses([
              proof(
                goal(lab(p001, hba1c_pct, 8.4)),
                by(fact("clinical-trial-screening.pl", clause(13)))
              ),
              proof(
                goal(>=(8.4, 7.0)),
                by(builtin(>=, 2))
              ),
              proof(
                goal(=<(8.4, 10.5)),
                by(builtin(=<, 2))
              )
            ])
          ),
          proof(
            goal('\\+'(exclusion_renal(p001))),
            by(builtin('\\+', 1))
          ),
          proof(
            goal('\\+'(exclusion_pregnancy(p001))),
            by(builtin('\\+', 1))
          )
        ])
      )
    ])
  )
).

reason(p002, "eGFR below renal safety threshold").
why(
  reason(p002, "eGFR below renal safety threshold"),
  proof(
    goal(reason(p002, "eGFR below renal safety threshold")),
    by(rule("clinical-trial-screening.pl", clause(35))),
    bindings([binding("Patient", p002)]),
    uses([
      proof(
        goal(exclusion_renal(p002)),
        by(rule("clinical-trial-screening.pl", clause(25))),
        bindings([binding("Patient", p002), binding("Egfr", 38.0)]),
        uses([
          proof(
            goal(lab(p002, egfr_ml_min, 38.0)),
            by(fact("clinical-trial-screening.pl", clause(18)))
          ),
          proof(
            goal(<(38.0, 45.0)),
            by(builtin(<, 2))
          )
        ])
      )
    ])
  )
).

reason(p003, "pregnancy exclusion applies").
why(
  reason(p003, "pregnancy exclusion applies"),
  proof(
    goal(reason(p003, "pregnancy exclusion applies")),
    by(rule("clinical-trial-screening.pl", clause(36))),
    bindings([binding("Patient", p003)]),
    uses([
      proof(
        goal(exclusion_pregnancy(p003)),
        by(rule("clinical-trial-screening.pl", clause(26))),
        bindings([binding("Patient", p003)]),
        uses([
          proof(
            goal(condition(p003, pregnant)),
            by(fact("clinical-trial-screening.pl", clause(21)))
          )
        ])
      )
    ])
  )
).

reason(p004, "HbA1c is outside protocol range").
why(
  reason(p004, "HbA1c is outside protocol range"),
  proof(
    goal(reason(p004, "HbA1c is outside protocol range")),
    by(rule("clinical-trial-screening.pl", clause(37))),
    bindings([binding("Patient", p004)]),
    uses([
      proof(
        goal(patient(p004)),
        by(fact("clinical-trial-screening.pl", clause(4)))
      ),
      proof(
        goal('\\+'(inclusion_hba1c(p004))),
        by(builtin('\\+', 1))
      )
    ])
  )
).

