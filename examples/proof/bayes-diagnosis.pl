evidenceTotal(case, 0.0016436300000000003).
why(
  evidenceTotal(case, 0.0016436300000000003),
  proof(
    goal(evidenceTotal(case, 0.0016436300000000003)),
    by(rule("bayes-diagnosis.pl", clause(46))),
    bindings([binding("Total", 0.0016436300000000003)]),
    uses([
      proof(
        goal(total_score_decimal(0.0016436300000000003)),
        by(fact("bayes-diagnosis.pl", clause(40)))
      )
    ])
  )
).

result(case, result(covid19)).
why(
  result(case, result(covid19)),
  proof(
    goal(result(case, result(covid19))),
    by(rule("bayes-diagnosis.pl", clause(47))),
    bindings([binding("Disease", covid19)]),
    uses([
      proof(
        goal(disease(covid19)),
        by(fact("bayes-diagnosis.pl", clause(1)))
      )
    ])
  )
).

result(case, result(influenza)).
why(
  result(case, result(influenza)),
  proof(
    goal(result(case, result(influenza))),
    by(rule("bayes-diagnosis.pl", clause(47))),
    bindings([binding("Disease", influenza)]),
    uses([
      proof(
        goal(disease(influenza)),
        by(fact("bayes-diagnosis.pl", clause(2)))
      )
    ])
  )
).

result(case, result(allergicRhinitis)).
why(
  result(case, result(allergicRhinitis)),
  proof(
    goal(result(case, result(allergicRhinitis))),
    by(rule("bayes-diagnosis.pl", clause(47))),
    bindings([binding("Disease", allergicRhinitis)]),
    uses([
      proof(
        goal(disease(allergicRhinitis)),
        by(fact("bayes-diagnosis.pl", clause(3)))
      )
    ])
  )
).

result(case, result(bacterialPneumonia)).
why(
  result(case, result(bacterialPneumonia)),
  proof(
    goal(result(case, result(bacterialPneumonia))),
    by(rule("bayes-diagnosis.pl", clause(47))),
    bindings([binding("Disease", bacterialPneumonia)]),
    uses([
      proof(
        goal(disease(bacterialPneumonia)),
        by(fact("bayes-diagnosis.pl", clause(4)))
      )
    ])
  )
).

disease(result(covid19), covid19).
why(
  disease(result(covid19), covid19),
  proof(
    goal(disease(result(covid19), covid19)),
    by(rule("bayes-diagnosis.pl", clause(48))),
    bindings([binding("Disease", covid19)]),
    uses([
      proof(
        goal(disease(covid19)),
        by(fact("bayes-diagnosis.pl", clause(1)))
      )
    ])
  )
).

disease(result(influenza), influenza).
why(
  disease(result(influenza), influenza),
  proof(
    goal(disease(result(influenza), influenza)),
    by(rule("bayes-diagnosis.pl", clause(48))),
    bindings([binding("Disease", influenza)]),
    uses([
      proof(
        goal(disease(influenza)),
        by(fact("bayes-diagnosis.pl", clause(2)))
      )
    ])
  )
).

disease(result(allergicRhinitis), allergicRhinitis).
why(
  disease(result(allergicRhinitis), allergicRhinitis),
  proof(
    goal(disease(result(allergicRhinitis), allergicRhinitis)),
    by(rule("bayes-diagnosis.pl", clause(48))),
    bindings([binding("Disease", allergicRhinitis)]),
    uses([
      proof(
        goal(disease(allergicRhinitis)),
        by(fact("bayes-diagnosis.pl", clause(3)))
      )
    ])
  )
).

disease(result(bacterialPneumonia), bacterialPneumonia).
why(
  disease(result(bacterialPneumonia), bacterialPneumonia),
  proof(
    goal(disease(result(bacterialPneumonia), bacterialPneumonia)),
    by(rule("bayes-diagnosis.pl", clause(48))),
    bindings([binding("Disease", bacterialPneumonia)]),
    uses([
      proof(
        goal(disease(bacterialPneumonia)),
        by(fact("bayes-diagnosis.pl", clause(4)))
      )
    ])
  )
).

unnormalized(result(covid19), 0.0015470000000000002).
why(
  unnormalized(result(covid19), 0.0015470000000000002),
  proof(
    goal(unnormalized(result(covid19), 0.0015470000000000002)),
    by(rule("bayes-diagnosis.pl", clause(49))),
    bindings([binding("Disease", covid19), binding("Score", 0.0015470000000000002)]),
    uses([
      proof(
        goal(score_decimal(covid19, 0.0015470000000000002)),
        by(fact("bayes-diagnosis.pl", clause(36)))
      )
    ])
  )
).

unnormalized(result(influenza), 0.000048000000000000015).
why(
  unnormalized(result(influenza), 0.000048000000000000015),
  proof(
    goal(unnormalized(result(influenza), 0.000048000000000000015)),
    by(rule("bayes-diagnosis.pl", clause(49))),
    bindings([binding("Disease", influenza), binding("Score", 0.000048000000000000015)]),
    uses([
      proof(
        goal(score_decimal(influenza, 0.000048000000000000015)),
        by(fact("bayes-diagnosis.pl", clause(37)))
      )
    ])
  )
).

unnormalized(result(allergicRhinitis), 7.499999999999999e-7).
why(
  unnormalized(result(allergicRhinitis), 7.499999999999999e-7),
  proof(
    goal(unnormalized(result(allergicRhinitis), 7.499999999999999e-7)),
    by(rule("bayes-diagnosis.pl", clause(49))),
    bindings([binding("Disease", allergicRhinitis), binding("Score", 7.499999999999999e-7)]),
    uses([
      proof(
        goal(score_decimal(allergicRhinitis, 7.499999999999999e-7)),
        by(fact("bayes-diagnosis.pl", clause(38)))
      )
    ])
  )
).

unnormalized(result(bacterialPneumonia), 0.000047879999999999996).
why(
  unnormalized(result(bacterialPneumonia), 0.000047879999999999996),
  proof(
    goal(unnormalized(result(bacterialPneumonia), 0.000047879999999999996)),
    by(rule("bayes-diagnosis.pl", clause(49))),
    bindings([binding("Disease", bacterialPneumonia), binding("Score", 0.000047879999999999996)]),
    uses([
      proof(
        goal(score_decimal(bacterialPneumonia, 0.000047879999999999996)),
        by(fact("bayes-diagnosis.pl", clause(39)))
      )
    ])
  )
).

