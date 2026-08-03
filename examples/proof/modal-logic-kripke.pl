modal_truth(all_accessible_worlds_clear, w0, box(atom(clear))).
why(
  modal_truth(all_accessible_worlds_clear, w0, box(atom(clear))),
  proof(
    goal(modal_truth(all_accessible_worlds_clear, w0, box(atom(clear)))),
    by(rule("modal-logic-kripke.pl", clause(21))),
    uses([
      proof(
        goal(mforces(w0, box(atom(clear)))),
        by(rule("modal-logic-kripke.pl", clause(19))),
        bindings([binding("World", w0), binding("Formula", atom(clear))]),
        uses([
          proof(
            goal(world(w0)),
            by(fact("modal-logic-kripke.pl", clause(1)))
          ),
          proof(
            goal('\\+'(box_counterexample(w0, atom(clear)))),
            by(builtin('\\+', 1))
          )
        ])
      )
    ])
  )
).

modal_truth(repair_is_possible, w0, diamond(atom(repaired))).
why(
  modal_truth(repair_is_possible, w0, diamond(atom(repaired))),
  proof(
    goal(modal_truth(repair_is_possible, w0, diamond(atom(repaired)))),
    by(rule("modal-logic-kripke.pl", clause(22))),
    uses([
      proof(
        goal(mforces(w0, diamond(atom(repaired)))),
        by(rule("modal-logic-kripke.pl", clause(18))),
        bindings([binding("World", w0), binding("Formula", atom(repaired)), binding("Next", w2)]),
        uses([
          proof(
            goal(accessible(w0, w2)),
            by(fact("modal-logic-kripke.pl", clause(6)))
          ),
          proof(
            goal(mforces(w2, atom(repaired))),
            by(rule("modal-logic-kripke.pl", clause(16))),
            bindings([binding("World", w2), binding("Prop", repaired)]),
            uses([
              proof(
                goal(true_at(w2, repaired)),
                by(fact("modal-logic-kripke.pl", clause(14)))
              )
            ])
          )
        ])
      )
    ])
  )
).

modal_truth(nested_possibility, w1, diamond(and(atom(clear), atom(clear)))).
why(
  modal_truth(nested_possibility, w1, diamond(and(atom(clear), atom(clear)))),
  proof(
    goal(modal_truth(nested_possibility, w1, diamond(and(atom(clear), atom(clear))))),
    by(rule("modal-logic-kripke.pl", clause(23))),
    uses([
      proof(
        goal(mforces(w1, diamond(and(atom(clear), atom(clear))))),
        by(rule("modal-logic-kripke.pl", clause(18))),
        bindings([binding("World", w1), binding("Formula", and(atom(clear), atom(clear))), binding("Next", w1)]),
        uses([
          proof(
            goal(accessible(w1, w1)),
            by(fact("modal-logic-kripke.pl", clause(7)))
          ),
          proof(
            goal(mforces(w1, and(atom(clear), atom(clear)))),
            by(rule("modal-logic-kripke.pl", clause(17))),
            bindings([binding("World", w1), binding("Left", atom(clear)), binding("Right", atom(clear))]),
            uses([
              proof(
                goal(mforces(w1, atom(clear))),
                by(rule("modal-logic-kripke.pl", clause(16))),
                bindings([binding("World", w1), binding("Prop", clear)]),
                uses([
                  proof(
                    goal(true_at(w1, clear)),
                    by(fact("modal-logic-kripke.pl", clause(11)))
                  )
                ])
              ),
              proof(
                goal(mforces(w1, atom(clear))),
                by(rule("modal-logic-kripke.pl", clause(16))),
                bindings([binding("World", w1), binding("Prop", clear)]),
                uses([
                  proof(
                    goal(true_at(w1, clear)),
                    by(fact("modal-logic-kripke.pl", clause(11)))
                  )
                ])
              )
            ])
          )
        ])
      )
    ])
  )
).

modal_countermodel(repair_not_necessary, w0).
why(
  modal_countermodel(repair_not_necessary, w0),
  proof(
    goal(modal_countermodel(repair_not_necessary, w0)),
    by(rule("modal-logic-kripke.pl", clause(24))),
    uses([
      proof(
        goal('\\+'(mforces(w0, box(atom(repaired))))),
        by(builtin('\\+', 1))
      )
    ])
  )
).

