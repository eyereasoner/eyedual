violation(alice, missed_obligation(obtain_consent)).
why(
  violation(alice, missed_obligation(obtain_consent)),
  proof(
    goal(violation(alice, missed_obligation(obtain_consent))),
    by(rule("deontic-logic.pl", clause(11))),
    bindings([binding("Actor", alice), binding("Action", obtain_consent)]),
    uses([
      proof(
        goal(obliged(alice, obtain_consent)),
        by(fact("deontic-logic.pl", clause(4)))
      ),
      proof(
        goal(not_performed(alice, obtain_consent)),
        by(fact("deontic-logic.pl", clause(9)))
      )
    ])
  )
).

violation(alice, prohibited_action(share_record)).
why(
  violation(alice, prohibited_action(share_record)),
  proof(
    goal(violation(alice, prohibited_action(share_record))),
    by(rule("deontic-logic.pl", clause(12))),
    bindings([binding("Actor", alice), binding("Action", share_record)]),
    uses([
      proof(
        goal(prohibited(alice, share_record)),
        by(fact("deontic-logic.pl", clause(5)))
      ),
      proof(
        goal(performed(alice, share_record)),
        by(fact("deontic-logic.pl", clause(7)))
      )
    ])
  )
).

compensation(alice, compensation(share_record, notify_dpo)).
why(
  compensation(alice, compensation(share_record, notify_dpo)),
  proof(
    goal(compensation(alice, compensation(share_record, notify_dpo))),
    by(rule("deontic-logic.pl", clause(16))),
    bindings([binding("Actor", alice), binding("Action", share_record), binding("Compensation", notify_dpo)]),
    uses([
      proof(
        goal(compensated_violation(alice, share_record, notify_dpo)),
        by(rule("deontic-logic.pl", clause(13))),
        bindings([binding("Actor", alice), binding("Action", share_record), binding("Compensation", notify_dpo)]),
        uses([
          proof(
            goal(prohibited(alice, share_record)),
            by(fact("deontic-logic.pl", clause(5)))
          ),
          proof(
            goal(performed(alice, share_record)),
            by(fact("deontic-logic.pl", clause(7)))
          ),
          proof(
            goal(compensates(share_record, notify_dpo)),
            by(fact("deontic-logic.pl", clause(6)))
          ),
          proof(
            goal(performed(alice, notify_dpo)),
            by(fact("deontic-logic.pl", clause(8)))
          )
        ])
      )
    ])
  )
).

status(alice, requires_review).
why(
  status(alice, requires_review),
  proof(
    goal(status(alice, requires_review)),
    by(rule("deontic-logic.pl", clause(17))),
    bindings([binding("Actor", alice), binding("_violation", missed_obligation(obtain_consent))]),
    uses([
      proof(
        goal(uncompensated_violation(alice, missed_obligation(obtain_consent))),
        by(rule("deontic-logic.pl", clause(14))),
        bindings([binding("Actor", alice), binding("Action", obtain_consent)]),
        uses([
          proof(
            goal(violation(alice, missed_obligation(obtain_consent))),
            by(rule("deontic-logic.pl", clause(11))),
            bindings([binding("Actor", alice), binding("Action", obtain_consent)]),
            uses([
              proof(
                goal(obliged(alice, obtain_consent)),
                by(fact("deontic-logic.pl", clause(4)))
              ),
              proof(
                goal(not_performed(alice, obtain_consent)),
                by(fact("deontic-logic.pl", clause(9)))
              )
            ])
          )
        ])
      )
    ])
  )
).

