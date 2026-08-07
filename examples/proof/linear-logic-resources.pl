linear_result(kitchen, [mill, mix, bake], [bread]).
why(
  linear_result(kitchen, [mill, mix, bake], [bread]),
  proof(
    goal(linear_result(kitchen, [mill, mix, bake], [bread])),
    by(rule("linear-logic-resources.pl", clause(13))),
    bindings([binding("Plan", [mill, mix, bake]), binding("Finalstate", [bread]), binding("State", [wheat, yeast, heat])]),
    uses([
      proof(
        goal(initial(kitchen, [wheat, yeast, heat])),
        by(fact("linear-logic-resources.pl", clause(1)))
      ),
      proof(
        goal(run_linear(3, [wheat, yeast, heat], [mill, mix, bake], [bread])),
        by(rule("linear-logic-resources.pl", clause(12))),
        bindings([binding("Steps", 3), binding("State0", [wheat, yeast, heat]), binding("Rule", mill), binding("Plan", [mix, bake]), binding("State2", [bread]), binding("State1", [flour, yeast, heat]), binding("Remaining", 2)]),
        uses([
          proof(
            goal(>(3, 0)),
            by(builtin(>, 2))
          ),
          proof(
            goal(linear_step([wheat, yeast, heat], mill, [flour, yeast, heat])),
            by(rule("linear-logic-resources.pl", clause(10))),
            bindings([binding("State0", [wheat, yeast, heat]), binding("Rule", mill), binding("State2", [flour, yeast, heat]), binding("Inputs", [wheat]), binding("Outputs", [flour]), binding("Rest", [yeast, heat])]),
            uses([
              proof(
                goal(linear_rule(mill, [wheat], [flour])),
                by(fact("linear-logic-resources.pl", clause(3)))
              ),
              proof(
                goal(consume_all([wheat], [wheat, yeast, heat], [yeast, heat])),
                by(rule("linear-logic-resources.pl", clause(9))),
                bindings([binding("Need", wheat), binding("Needs", []), binding("State0", [wheat, yeast, heat]), binding("State2", [yeast, heat]), binding("State1", [yeast, heat])]),
                uses([
                  proof(
                    goal(select(wheat, [wheat, yeast, heat], [yeast, heat])),
                    by(library(select, 3))
                  ),
                  proof(
                    goal(consume_all([], [yeast, heat], [yeast, heat])),
                    by(fact("linear-logic-resources.pl", clause(8))),
                    bindings([binding("State", [yeast, heat])])
                  )
                ])
              ),
              proof(
                goal(append([flour], [yeast, heat], [flour, yeast, heat])),
                by(library(append, 3))
              )
            ])
          ),
          proof(
            goal(is(2, '-'(3, 1))),
            by(builtin(is, 2))
          ),
          proof(
            goal(run_linear(2, [flour, yeast, heat], [mix, bake], [bread])),
            by(rule("linear-logic-resources.pl", clause(12))),
            bindings([binding("Steps", 2), binding("State0", [flour, yeast, heat]), binding("Rule", mix), binding("Plan", [bake]), binding("State2", [bread]), binding("State1", [dough, heat]), binding("Remaining", 1)]),
            uses([
              proof(
                goal(>(2, 0)),
                by(builtin(>, 2))
              ),
              proof(
                goal(linear_step([flour, yeast, heat], mix, [dough, heat])),
                by(rule("linear-logic-resources.pl", clause(10))),
                bindings([binding("State0", [flour, yeast, heat]), binding("Rule", mix), binding("State2", [dough, heat]), binding("Inputs", [flour, yeast]), binding("Outputs", [dough]), binding("Rest", [heat])]),
                uses([
                  proof(
                    goal(linear_rule(mix, [flour, yeast], [dough])),
                    by(fact("linear-logic-resources.pl", clause(4)))
                  ),
                  proof(
                    goal(consume_all([flour, yeast], [flour, yeast, heat], [heat])),
                    by(rule("linear-logic-resources.pl", clause(9))),
                    bindings([binding("Need", flour), binding("Needs", [yeast]), binding("State0", [flour, yeast, heat]), binding("State2", [heat]), binding("State1", [yeast, heat])]),
                    uses([
                      proof(
                        goal(select(flour, [flour, yeast, heat], [yeast, heat])),
                        by(library(select, 3))
                      ),
                      proof(
                        goal(consume_all([yeast], [yeast, heat], [heat])),
                        by(rule("linear-logic-resources.pl", clause(9))),
                        bindings([binding("Need", yeast), binding("Needs", []), binding("State0", [yeast, heat]), binding("State2", [heat]), binding("State1", [heat])]),
                        uses([
                          proof(
                            goal(select(yeast, [yeast, heat], [heat])),
                            by(library(select, 3))
                          ),
                          proof(
                            goal(consume_all([], [heat], [heat])),
                            by(fact("linear-logic-resources.pl", clause(8))),
                            bindings([binding("State", [heat])])
                          )
                        ])
                      )
                    ])
                  ),
                  proof(
                    goal(append([dough], [heat], [dough, heat])),
                    by(library(append, 3))
                  )
                ])
              ),
              proof(
                goal(is(1, '-'(2, 1))),
                by(builtin(is, 2))
              ),
              proof(
                goal(run_linear(1, [dough, heat], [bake], [bread])),
                by(rule("linear-logic-resources.pl", clause(12))),
                bindings([binding("Steps", 1), binding("State0", [dough, heat]), binding("Rule", bake), binding("Plan", []), binding("State2", [bread]), binding("State1", [bread]), binding("Remaining", 0)]),
                uses([
                  proof(
                    goal(>(1, 0)),
                    by(builtin(>, 2))
                  ),
                  proof(
                    goal(linear_step([dough, heat], bake, [bread])),
                    by(rule("linear-logic-resources.pl", clause(10))),
                    bindings([binding("State0", [dough, heat]), binding("Rule", bake), binding("State2", [bread]), binding("Inputs", [dough, heat]), binding("Outputs", [bread]), binding("Rest", [])]),
                    uses([
                      proof(
                        goal(linear_rule(bake, [dough, heat], [bread])),
                        by(fact("linear-logic-resources.pl", clause(5)))
                      ),
                      proof(
                        goal(consume_all([dough, heat], [dough, heat], [])),
                        by(rule("linear-logic-resources.pl", clause(9))),
                        bindings([binding("Need", dough), binding("Needs", [heat]), binding("State0", [dough, heat]), binding("State2", []), binding("State1", [heat])]),
                        uses([
                          proof(
                            goal(select(dough, [dough, heat], [heat])),
                            by(library(select, 3))
                          ),
                          proof(
                            goal(consume_all([heat], [heat], [])),
                            by(rule("linear-logic-resources.pl", clause(9))),
                            bindings([binding("Need", heat), binding("Needs", []), binding("State0", [heat]), binding("State2", []), binding("State1", [])]),
                            uses([
                              proof(
                                goal(select(heat, [heat], [])),
                                by(library(select, 3))
                              ),
                              proof(
                                goal(consume_all([], [], [])),
                                by(fact("linear-logic-resources.pl", clause(8))),
                                bindings([binding("State", [])])
                              )
                            ])
                          )
                        ])
                      ),
                      proof(
                        goal(append([bread], [], [bread])),
                        by(library(append, 3))
                      )
                    ])
                  ),
                  proof(
                    goal(is(0, '-'(1, 1))),
                    by(builtin(is, 2))
                  ),
                  proof(
                    goal(run_linear(0, [bread], [], [bread])),
                    by(fact("linear-logic-resources.pl", clause(11))),
                    bindings([binding("State", [bread])])
                  )
                ])
              )
            ])
          )
        ])
      ),
      proof(
        goal(=([bread], [bread])),
        by(builtin(=, 2))
      )
    ])
  )
).

linear_check(double_spend_rejected, yes).
why(
  linear_check(double_spend_rejected, yes),
  proof(
    goal(linear_check(double_spend_rejected, yes)),
    by(rule("linear-logic-resources.pl", clause(14))),
    bindings([binding("State", [coin])]),
    uses([
      proof(
        goal(initial(wallet, [coin])),
        by(fact("linear-logic-resources.pl", clause(2)))
      ),
      proof(
        goal('\\+'(run_linear(2, [coin], [buy_flour, buy_yeast], _finalstate))),
        by(builtin('\\+', 1))
      )
    ])
  )
).

