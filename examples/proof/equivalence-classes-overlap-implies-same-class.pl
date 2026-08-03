sameClassBecauseOfSharedMember(a, b, a).
why(
  sameClassBecauseOfSharedMember(a, b, a),
  proof(
    goal(sameClassBecauseOfSharedMember(a, b, a)),
    by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(6))),
    bindings([binding("X", a), binding("Y", b), binding("Z", a)]),
    uses([
      proof(
        goal(inClassOf(a, a)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", a), binding("X", a), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          ),
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(inClassOf(a, b)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", a), binding("X", b), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          ),
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(sameClass(a, b)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(5))),
        bindings([binding("X", a), binding("Y", b), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          ),
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(\=(a, b)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameClassBecauseOfSharedMember(a, c, a).
why(
  sameClassBecauseOfSharedMember(a, c, a),
  proof(
    goal(sameClassBecauseOfSharedMember(a, c, a)),
    by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(6))),
    bindings([binding("X", a), binding("Y", c), binding("Z", a)]),
    uses([
      proof(
        goal(inClassOf(a, a)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", a), binding("X", a), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          ),
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(inClassOf(a, c)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", a), binding("X", c), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          ),
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(sameClass(a, c)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(5))),
        bindings([binding("X", a), binding("Y", c), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          ),
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(\=(a, c)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameClassBecauseOfSharedMember(b, a, a).
why(
  sameClassBecauseOfSharedMember(b, a, a),
  proof(
    goal(sameClassBecauseOfSharedMember(b, a, a)),
    by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(6))),
    bindings([binding("X", b), binding("Y", a), binding("Z", a)]),
    uses([
      proof(
        goal(inClassOf(a, b)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", a), binding("X", b), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          ),
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(inClassOf(a, a)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", a), binding("X", a), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          ),
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(sameClass(b, a)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(5))),
        bindings([binding("X", b), binding("Y", a), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          ),
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(\=(b, a)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameClassBecauseOfSharedMember(b, c, a).
why(
  sameClassBecauseOfSharedMember(b, c, a),
  proof(
    goal(sameClassBecauseOfSharedMember(b, c, a)),
    by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(6))),
    bindings([binding("X", b), binding("Y", c), binding("Z", a)]),
    uses([
      proof(
        goal(inClassOf(a, b)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", a), binding("X", b), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          ),
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(inClassOf(a, c)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", a), binding("X", c), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          ),
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(sameClass(b, c)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(5))),
        bindings([binding("X", b), binding("Y", c), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          ),
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(\=(b, c)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameClassBecauseOfSharedMember(c, a, a).
why(
  sameClassBecauseOfSharedMember(c, a, a),
  proof(
    goal(sameClassBecauseOfSharedMember(c, a, a)),
    by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(6))),
    bindings([binding("X", c), binding("Y", a), binding("Z", a)]),
    uses([
      proof(
        goal(inClassOf(a, c)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", a), binding("X", c), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          ),
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(inClassOf(a, a)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", a), binding("X", a), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          ),
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(sameClass(c, a)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(5))),
        bindings([binding("X", c), binding("Y", a), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          ),
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(\=(c, a)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameClassBecauseOfSharedMember(c, b, a).
why(
  sameClassBecauseOfSharedMember(c, b, a),
  proof(
    goal(sameClassBecauseOfSharedMember(c, b, a)),
    by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(6))),
    bindings([binding("X", c), binding("Y", b), binding("Z", a)]),
    uses([
      proof(
        goal(inClassOf(a, c)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", a), binding("X", c), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          ),
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(inClassOf(a, b)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", a), binding("X", b), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          ),
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(sameClass(c, b)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(5))),
        bindings([binding("X", c), binding("Y", b), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          ),
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(\=(c, b)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameClassBecauseOfSharedMember(a, b, b).
why(
  sameClassBecauseOfSharedMember(a, b, b),
  proof(
    goal(sameClassBecauseOfSharedMember(a, b, b)),
    by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(6))),
    bindings([binding("X", a), binding("Y", b), binding("Z", b)]),
    uses([
      proof(
        goal(inClassOf(b, a)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", b), binding("X", a), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          ),
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(inClassOf(b, b)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", b), binding("X", b), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          ),
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(sameClass(a, b)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(5))),
        bindings([binding("X", a), binding("Y", b), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          ),
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(\=(a, b)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameClassBecauseOfSharedMember(a, c, b).
why(
  sameClassBecauseOfSharedMember(a, c, b),
  proof(
    goal(sameClassBecauseOfSharedMember(a, c, b)),
    by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(6))),
    bindings([binding("X", a), binding("Y", c), binding("Z", b)]),
    uses([
      proof(
        goal(inClassOf(b, a)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", b), binding("X", a), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          ),
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(inClassOf(b, c)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", b), binding("X", c), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          ),
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(sameClass(a, c)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(5))),
        bindings([binding("X", a), binding("Y", c), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          ),
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(\=(a, c)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameClassBecauseOfSharedMember(b, a, b).
why(
  sameClassBecauseOfSharedMember(b, a, b),
  proof(
    goal(sameClassBecauseOfSharedMember(b, a, b)),
    by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(6))),
    bindings([binding("X", b), binding("Y", a), binding("Z", b)]),
    uses([
      proof(
        goal(inClassOf(b, b)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", b), binding("X", b), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          ),
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(inClassOf(b, a)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", b), binding("X", a), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          ),
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(sameClass(b, a)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(5))),
        bindings([binding("X", b), binding("Y", a), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          ),
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(\=(b, a)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameClassBecauseOfSharedMember(b, c, b).
why(
  sameClassBecauseOfSharedMember(b, c, b),
  proof(
    goal(sameClassBecauseOfSharedMember(b, c, b)),
    by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(6))),
    bindings([binding("X", b), binding("Y", c), binding("Z", b)]),
    uses([
      proof(
        goal(inClassOf(b, b)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", b), binding("X", b), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          ),
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(inClassOf(b, c)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", b), binding("X", c), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          ),
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(sameClass(b, c)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(5))),
        bindings([binding("X", b), binding("Y", c), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          ),
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(\=(b, c)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameClassBecauseOfSharedMember(c, a, b).
why(
  sameClassBecauseOfSharedMember(c, a, b),
  proof(
    goal(sameClassBecauseOfSharedMember(c, a, b)),
    by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(6))),
    bindings([binding("X", c), binding("Y", a), binding("Z", b)]),
    uses([
      proof(
        goal(inClassOf(b, c)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", b), binding("X", c), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          ),
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(inClassOf(b, a)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", b), binding("X", a), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          ),
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(sameClass(c, a)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(5))),
        bindings([binding("X", c), binding("Y", a), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          ),
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(\=(c, a)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameClassBecauseOfSharedMember(c, b, b).
why(
  sameClassBecauseOfSharedMember(c, b, b),
  proof(
    goal(sameClassBecauseOfSharedMember(c, b, b)),
    by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(6))),
    bindings([binding("X", c), binding("Y", b), binding("Z", b)]),
    uses([
      proof(
        goal(inClassOf(b, c)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", b), binding("X", c), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          ),
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(inClassOf(b, b)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", b), binding("X", b), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          ),
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(sameClass(c, b)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(5))),
        bindings([binding("X", c), binding("Y", b), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          ),
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(\=(c, b)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameClassBecauseOfSharedMember(a, b, c).
why(
  sameClassBecauseOfSharedMember(a, b, c),
  proof(
    goal(sameClassBecauseOfSharedMember(a, b, c)),
    by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(6))),
    bindings([binding("X", a), binding("Y", b), binding("Z", c)]),
    uses([
      proof(
        goal(inClassOf(c, a)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", c), binding("X", a), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          ),
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(inClassOf(c, b)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", c), binding("X", b), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          ),
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(sameClass(a, b)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(5))),
        bindings([binding("X", a), binding("Y", b), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          ),
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(\=(a, b)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameClassBecauseOfSharedMember(a, c, c).
why(
  sameClassBecauseOfSharedMember(a, c, c),
  proof(
    goal(sameClassBecauseOfSharedMember(a, c, c)),
    by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(6))),
    bindings([binding("X", a), binding("Y", c), binding("Z", c)]),
    uses([
      proof(
        goal(inClassOf(c, a)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", c), binding("X", a), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          ),
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(inClassOf(c, c)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", c), binding("X", c), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          ),
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(sameClass(a, c)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(5))),
        bindings([binding("X", a), binding("Y", c), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          ),
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(\=(a, c)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameClassBecauseOfSharedMember(b, a, c).
why(
  sameClassBecauseOfSharedMember(b, a, c),
  proof(
    goal(sameClassBecauseOfSharedMember(b, a, c)),
    by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(6))),
    bindings([binding("X", b), binding("Y", a), binding("Z", c)]),
    uses([
      proof(
        goal(inClassOf(c, b)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", c), binding("X", b), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          ),
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(inClassOf(c, a)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", c), binding("X", a), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          ),
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(sameClass(b, a)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(5))),
        bindings([binding("X", b), binding("Y", a), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          ),
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(\=(b, a)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameClassBecauseOfSharedMember(b, c, c).
why(
  sameClassBecauseOfSharedMember(b, c, c),
  proof(
    goal(sameClassBecauseOfSharedMember(b, c, c)),
    by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(6))),
    bindings([binding("X", b), binding("Y", c), binding("Z", c)]),
    uses([
      proof(
        goal(inClassOf(c, b)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", c), binding("X", b), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          ),
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(inClassOf(c, c)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", c), binding("X", c), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          ),
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(sameClass(b, c)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(5))),
        bindings([binding("X", b), binding("Y", c), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          ),
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(\=(b, c)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameClassBecauseOfSharedMember(c, a, c).
why(
  sameClassBecauseOfSharedMember(c, a, c),
  proof(
    goal(sameClassBecauseOfSharedMember(c, a, c)),
    by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(6))),
    bindings([binding("X", c), binding("Y", a), binding("Z", c)]),
    uses([
      proof(
        goal(inClassOf(c, c)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", c), binding("X", c), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          ),
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(inClassOf(c, a)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", c), binding("X", a), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          ),
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(sameClass(c, a)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(5))),
        bindings([binding("X", c), binding("Y", a), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          ),
          proof(
            goal(classMember(class_abc, a)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)))
          )
        ])
      ),
      proof(
        goal(\=(c, a)),
        by(builtin(\=, 2))
      )
    ])
  )
).

sameClassBecauseOfSharedMember(c, b, c).
why(
  sameClassBecauseOfSharedMember(c, b, c),
  proof(
    goal(sameClassBecauseOfSharedMember(c, b, c)),
    by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(6))),
    bindings([binding("X", c), binding("Y", b), binding("Z", c)]),
    uses([
      proof(
        goal(inClassOf(c, c)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", c), binding("X", c), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          ),
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          )
        ])
      ),
      proof(
        goal(inClassOf(c, b)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(4))),
        bindings([binding("U", c), binding("X", b), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          ),
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(sameClass(c, b)),
        by(rule("equivalence-classes-overlap-implies-same-class.pl", clause(5))),
        bindings([binding("X", c), binding("Y", b), binding("Class", class_abc)]),
        uses([
          proof(
            goal(classMember(class_abc, c)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)))
          ),
          proof(
            goal(classMember(class_abc, b)),
            by(fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)))
          )
        ])
      ),
      proof(
        goal(\=(c, b)),
        by(builtin(\=, 2))
      )
    ])
  )
).

