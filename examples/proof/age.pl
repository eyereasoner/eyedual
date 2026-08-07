ageAbove(patH, 'P80Y').
why(
  ageAbove(patH, 'P80Y'),
  proof(
    goal(ageAbove(patH, 'P80Y')),
    by(rule("age.pl", clause(4))),
    bindings([binding("S", patH), binding("A", 'P80Y'), binding("B", '1944-08-21'), binding("D", '2026-05-30'), binding("F", 'P81Y9M9D')]),
    uses([
      proof(
        goal(birthDay(patH, '1944-08-21')),
        by(fact("age.pl", clause(1)))
      ),
      proof(
        goal(duration(check, 'P80Y')),
        by(fact("age.pl", clause(2)))
      ),
      proof(
        goal(local_time('2026-05-30')),
        by(fact("age.pl", clause(3)))
      ),
      proof(
        goal(difference('2026-05-30', '1944-08-21', 'P81Y9M9D')),
        by(library(difference, 3))
      ),
      proof(
        goal(@>('P81Y9M9D', 'P80Y')),
        by(builtin(@>, 2))
      )
    ])
  )
).

holds_result(test, true).
why(
  holds_result(test, true),
  proof(
    goal(holds_result(test, true)),
    by(rule("age.pl", clause(5))),
    bindings([binding("__anon0", patH)]),
    uses([
      proof(
        goal(ageAbove(patH, 'P80Y')),
        by(rule("age.pl", clause(4))),
        bindings([binding("S", patH), binding("A", 'P80Y'), binding("B", '1944-08-21'), binding("D", '2026-05-30'), binding("F", 'P81Y9M9D')]),
        uses([
          proof(
            goal(birthDay(patH, '1944-08-21')),
            by(fact("age.pl", clause(1)))
          ),
          proof(
            goal(duration(check, 'P80Y')),
            by(fact("age.pl", clause(2)))
          ),
          proof(
            goal(local_time('2026-05-30')),
            by(fact("age.pl", clause(3)))
          ),
          proof(
            goal(difference('2026-05-30', '1944-08-21', 'P81Y9M9D')),
            by(library(difference, 3))
          ),
          proof(
            goal(@>('P81Y9M9D', 'P80Y')),
            by(builtin(@>, 2))
          )
        ])
      )
    ])
  )
).

