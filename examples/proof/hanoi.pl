answer(3, [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]]).
why(
  answer(3, [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]]),
  proof(
    goal(answer(3, [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]])),
    by(rule("hanoi.pl", clause(3))),
    bindings([binding("Moves", [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]])]),
    uses([
      proof(
        goal(hanoi(3, left, right, center, [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]])),
        by(rule("hanoi.pl", clause(2))),
        bindings([binding("N", 3), binding("From", left), binding("To", right), binding("Via", center), binding("Moves", [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]]), binding("N1", 2), binding("Before", [[left, right], [left, center], [right, center]]), binding("After", [[center, left], [center, right], [left, right]])]),
        uses([
          proof(
            goal(>(3, 0)),
            by(builtin(>, 2))
          ),
          proof(
            goal(is(2, '-'(3, 1))),
            by(builtin(is, 2))
          ),
          proof(
            goal(hanoi(2, left, center, right, [[left, right], [left, center], [right, center]])),
            by(rule("hanoi.pl", clause(2))),
            bindings([binding("N", 2), binding("From", left), binding("To", center), binding("Via", right), binding("Moves", [[left, right], [left, center], [right, center]]), binding("N1", 1), binding("Before", [[left, right]]), binding("After", [[right, center]])]),
            uses([
              proof(
                goal(>(2, 0)),
                by(builtin(>, 2))
              ),
              proof(
                goal(is(1, '-'(2, 1))),
                by(builtin(is, 2))
              ),
              proof(
                goal(hanoi(1, left, right, center, [[left, right]])),
                by(rule("hanoi.pl", clause(2))),
                bindings([binding("N", 1), binding("From", left), binding("To", right), binding("Via", center), binding("Moves", [[left, right]]), binding("N1", 0), binding("Before", []), binding("After", [])]),
                uses([
                  proof(
                    goal(>(1, 0)),
                    by(builtin(>, 2))
                  ),
                  proof(
                    goal(is(0, '-'(1, 1))),
                    by(builtin(is, 2))
                  ),
                  proof(
                    goal(hanoi(0, left, center, right, [])),
                    by(fact("hanoi.pl", clause(1))),
                    bindings([binding("_from", left), binding("_to", center), binding("_via", right)])
                  ),
                  proof(
                    goal(hanoi(0, center, right, left, [])),
                    by(fact("hanoi.pl", clause(1))),
                    bindings([binding("_from", center), binding("_to", right), binding("_via", left)])
                  ),
                  proof(
                    goal(append([], [[left, right]], [[left, right]])),
                    by(library(append, 3))
                  )
                ])
              ),
              proof(
                goal(hanoi(1, right, center, left, [[right, center]])),
                by(rule("hanoi.pl", clause(2))),
                bindings([binding("N", 1), binding("From", right), binding("To", center), binding("Via", left), binding("Moves", [[right, center]]), binding("N1", 0), binding("Before", []), binding("After", [])]),
                uses([
                  proof(
                    goal(>(1, 0)),
                    by(builtin(>, 2))
                  ),
                  proof(
                    goal(is(0, '-'(1, 1))),
                    by(builtin(is, 2))
                  ),
                  proof(
                    goal(hanoi(0, right, left, center, [])),
                    by(fact("hanoi.pl", clause(1))),
                    bindings([binding("_from", right), binding("_to", left), binding("_via", center)])
                  ),
                  proof(
                    goal(hanoi(0, left, center, right, [])),
                    by(fact("hanoi.pl", clause(1))),
                    bindings([binding("_from", left), binding("_to", center), binding("_via", right)])
                  ),
                  proof(
                    goal(append([], [[right, center]], [[right, center]])),
                    by(library(append, 3))
                  )
                ])
              ),
              proof(
                goal(append([[left, right]], [[left, center], [right, center]], [[left, right], [left, center], [right, center]])),
                by(library(append, 3))
              )
            ])
          ),
          proof(
            goal(hanoi(2, center, right, left, [[center, left], [center, right], [left, right]])),
            by(rule("hanoi.pl", clause(2))),
            bindings([binding("N", 2), binding("From", center), binding("To", right), binding("Via", left), binding("Moves", [[center, left], [center, right], [left, right]]), binding("N1", 1), binding("Before", [[center, left]]), binding("After", [[left, right]])]),
            uses([
              proof(
                goal(>(2, 0)),
                by(builtin(>, 2))
              ),
              proof(
                goal(is(1, '-'(2, 1))),
                by(builtin(is, 2))
              ),
              proof(
                goal(hanoi(1, center, left, right, [[center, left]])),
                by(rule("hanoi.pl", clause(2))),
                bindings([binding("N", 1), binding("From", center), binding("To", left), binding("Via", right), binding("Moves", [[center, left]]), binding("N1", 0), binding("Before", []), binding("After", [])]),
                uses([
                  proof(
                    goal(>(1, 0)),
                    by(builtin(>, 2))
                  ),
                  proof(
                    goal(is(0, '-'(1, 1))),
                    by(builtin(is, 2))
                  ),
                  proof(
                    goal(hanoi(0, center, right, left, [])),
                    by(fact("hanoi.pl", clause(1))),
                    bindings([binding("_from", center), binding("_to", right), binding("_via", left)])
                  ),
                  proof(
                    goal(hanoi(0, right, left, center, [])),
                    by(fact("hanoi.pl", clause(1))),
                    bindings([binding("_from", right), binding("_to", left), binding("_via", center)])
                  ),
                  proof(
                    goal(append([], [[center, left]], [[center, left]])),
                    by(library(append, 3))
                  )
                ])
              ),
              proof(
                goal(hanoi(1, left, right, center, [[left, right]])),
                by(rule("hanoi.pl", clause(2))),
                bindings([binding("N", 1), binding("From", left), binding("To", right), binding("Via", center), binding("Moves", [[left, right]]), binding("N1", 0), binding("Before", []), binding("After", [])]),
                uses([
                  proof(
                    goal(>(1, 0)),
                    by(builtin(>, 2))
                  ),
                  proof(
                    goal(is(0, '-'(1, 1))),
                    by(builtin(is, 2))
                  ),
                  proof(
                    goal(hanoi(0, left, center, right, [])),
                    by(fact("hanoi.pl", clause(1))),
                    bindings([binding("_from", left), binding("_to", center), binding("_via", right)])
                  ),
                  proof(
                    goal(hanoi(0, center, right, left, [])),
                    by(fact("hanoi.pl", clause(1))),
                    bindings([binding("_from", center), binding("_to", right), binding("_via", left)])
                  ),
                  proof(
                    goal(append([], [[left, right]], [[left, right]])),
                    by(library(append, 3))
                  )
                ])
              ),
              proof(
                goal(append([[center, left]], [[center, right], [left, right]], [[center, left], [center, right], [left, right]])),
                by(library(append, 3))
              )
            ])
          ),
          proof(
            goal(append([[left, right], [left, center], [right, center]], [[left, right], [center, left], [center, right], [left, right]], [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]])),
            by(library(append, 3))
          )
        ])
      )
    ])
  )
).

