intuitionistic_truth(monotone_p_reaches_both, both, atom(p)).
why(
  intuitionistic_truth(monotone_p_reaches_both, both, atom(p)),
  proof(
    goal(intuitionistic_truth(monotone_p_reaches_both, both, atom(p))),
    by(rule("intuitionistic-logic-kripke.pl", clause(20))),
    uses([
      proof(
        goal(forces(both, atom(p))),
        by(rule("intuitionistic-logic-kripke.pl", clause(13))),
        bindings([binding("World", both), binding("Prop", p), binding("Someworld", left)]),
        uses([
          proof(
            goal(leq(left, both)),
            by(rule("intuitionistic-logic-kripke.pl", clause(12))),
            bindings([binding("From", left), binding("To", both), binding("Mid", both)]),
            uses([
              proof(
                goal(step(left, both)),
                by(fact("intuitionistic-logic-kripke.pl", clause(7)))
              ),
              proof(
                goal(leq(both, both)),
                by(rule("intuitionistic-logic-kripke.pl", clause(11))),
                bindings([binding("World", both)]),
                uses([
                  proof(
                    goal(world(both)),
                    by(fact("intuitionistic-logic-kripke.pl", clause(4)))
                  )
                ])
              )
            ])
          ),
          proof(
            goal(base(left, p)),
            by(fact("intuitionistic-logic-kripke.pl", clause(9)))
          )
        ])
      )
    ])
  )
).

intuitionistic_truth(constructive_case_analysis, root, implies(atom(p), or(atom(p), atom(q)))).
why(
  intuitionistic_truth(constructive_case_analysis, root, implies(atom(p), or(atom(p), atom(q)))),
  proof(
    goal(intuitionistic_truth(constructive_case_analysis, root, implies(atom(p), or(atom(p), atom(q))))),
    by(rule("intuitionistic-logic-kripke.pl", clause(21))),
    uses([
      proof(
        goal(forces(root, implies(atom(p), or(atom(p), atom(q))))),
        by(rule("intuitionistic-logic-kripke.pl", clause(17))),
        bindings([binding("World", root), binding("Left", atom(p)), binding("Right", or(atom(p), atom(q)))]),
        uses([
          proof(
            goal(world(root)),
            by(fact("intuitionistic-logic-kripke.pl", clause(1)))
          ),
          proof(
            goal('\\+'(bad_implication(root, atom(p), or(atom(p), atom(q))))),
            by(builtin('\\+', 1))
          )
        ])
      )
    ])
  )
).

intuitionistic_truth(double_negated_branch_information, root, neg(neg(or(atom(p), atom(q))))).
why(
  intuitionistic_truth(double_negated_branch_information, root, neg(neg(or(atom(p), atom(q))))),
  proof(
    goal(intuitionistic_truth(double_negated_branch_information, root, neg(neg(or(atom(p), atom(q)))))),
    by(rule("intuitionistic-logic-kripke.pl", clause(22))),
    uses([
      proof(
        goal(forces(root, neg(neg(or(atom(p), atom(q)))))),
        by(rule("intuitionistic-logic-kripke.pl", clause(18))),
        bindings([binding("World", root), binding("Formula", neg(or(atom(p), atom(q))))]),
        uses([
          proof(
            goal(forces(root, implies(neg(or(atom(p), atom(q))), bottom))),
            by(rule("intuitionistic-logic-kripke.pl", clause(17))),
            bindings([binding("World", root), binding("Left", neg(or(atom(p), atom(q)))), binding("Right", bottom)]),
            uses([
              proof(
                goal(world(root)),
                by(fact("intuitionistic-logic-kripke.pl", clause(1)))
              ),
              proof(
                goal('\\+'(bad_implication(root, neg(or(atom(p), atom(q))), bottom))),
                by(builtin('\\+', 1))
              )
            ])
          )
        ])
      )
    ])
  )
).

intuitionistic_countermodel(root_does_not_decide_branch, root, or(atom(p), atom(q))).
why(
  intuitionistic_countermodel(root_does_not_decide_branch, root, or(atom(p), atom(q))),
  proof(
    goal(intuitionistic_countermodel(root_does_not_decide_branch, root, or(atom(p), atom(q)))),
    by(rule("intuitionistic-logic-kripke.pl", clause(23))),
    uses([
      proof(
        goal('\\+'(forces(root, or(atom(p), atom(q))))),
        by(builtin('\\+', 1))
      )
    ])
  )
).

intuitionistic_countermodel(excluded_middle_not_forced, root, or(atom(p), neg(atom(p)))).
why(
  intuitionistic_countermodel(excluded_middle_not_forced, root, or(atom(p), neg(atom(p)))),
  proof(
    goal(intuitionistic_countermodel(excluded_middle_not_forced, root, or(atom(p), neg(atom(p))))),
    by(rule("intuitionistic-logic-kripke.pl", clause(24))),
    uses([
      proof(
        goal('\\+'(forces(root, or(atom(p), neg(atom(p)))))),
        by(builtin('\\+', 1))
      )
    ])
  )
).

