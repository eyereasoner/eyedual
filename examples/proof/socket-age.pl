ageAbove(patH, "P80Y").
why(
  ageAbove(patH, "P80Y"),
  proof(
    goal(ageAbove(patH, "P80Y")),
    by(rule("socket-age.pl", clause(11))),
    bindings([binding("S", patH), binding("A", "P80Y"), binding("B", "1944-08-21"), binding("D", "2026-05-30"), binding("F", "P81Y9M9D")]),
    uses([
      proof(
        goal(birthDay(patH, "1944-08-21")),
        by(fact("socket-age.pl", clause(8)))
      ),
      proof(
        goal(duration(check, "P80Y")),
        by(fact("socket-age.pl", clause(9)))
      ),
      proof(
        goal(today("2026-05-30")),
        by(fact("socket-age.pl", clause(10)))
      ),
      proof(
        goal(difference("2026-05-30", "1944-08-21", "P81Y9M9D")),
        by(builtin(difference, 3))
      ),
      proof(
        goal(@>("P81Y9M9D", "P80Y")),
        by(builtin(@>, 2))
      )
    ])
  )
).

