sameInputByCompositeInjectivity(h, a, b).
why(
  sameInputByCompositeInjectivity(h, a, b),
  proof(
    goal(sameInputByCompositeInjectivity(h, a, b)),
    by(rule("composition-of-injective-functions-is-injective.pl", clause(20))),
    bindings([binding("H", h), binding("X", a), binding("Y", b), binding("G", g), binding("F", f), binding("Z", e)]),
    uses([
      proof(
        goal(compositeOf(h, g, f)),
        by(fact("composition-of-injective-functions-is-injective.pl", clause(17)))
      ),
      proof(
        goal(injective(g)),
        by(fact("composition-of-injective-functions-is-injective.pl", clause(16)))
      ),
      proof(
        goal(injective(f)),
        by(fact("composition-of-injective-functions-is-injective.pl", clause(15)))
      ),
      proof(
        goal(app(h, a, e)),
        by(rule("composition-of-injective-functions-is-injective.pl", clause(18))),
        bindings([binding("H", h), binding("X", a), binding("Z", e), binding("G", g), binding("F", f), binding("Y", c)]),
        uses([
          proof(
            goal(compositeOf(h, g, f)),
            by(fact("composition-of-injective-functions-is-injective.pl", clause(17)))
          ),
          proof(
            goal(app(f, a, c)),
            by(fact("composition-of-injective-functions-is-injective.pl", clause(11)))
          ),
          proof(
            goal(app(g, c, e)),
            by(fact("composition-of-injective-functions-is-injective.pl", clause(13)))
          )
        ])
      ),
      proof(
        goal(app(h, b, e)),
        by(rule("composition-of-injective-functions-is-injective.pl", clause(18))),
        bindings([binding("H", h), binding("X", b), binding("Z", e), binding("G", g), binding("F", f), binding("Y", d)]),
        uses([
          proof(
            goal(compositeOf(h, g, f)),
            by(fact("composition-of-injective-functions-is-injective.pl", clause(17)))
          ),
          proof(
            goal(app(f, b, d)),
            by(fact("composition-of-injective-functions-is-injective.pl", clause(12)))
          ),
          proof(
            goal(app(g, d, e)),
            by(fact("composition-of-injective-functions-is-injective.pl", clause(14)))
          )
        ])
      ),
      proof(
        goal(sameTerm(a, b)),
        by(rule("composition-of-injective-functions-is-injective.pl", clause(10))),
        bindings([binding("Y", a), binding("X", b)]),
        uses([
          proof(
            goal(sameTerm(b, a)),
            by(rule("composition-of-injective-functions-is-injective.pl", clause(19))),
            bindings([binding("X", b), binding("Y", a), binding("F", f), binding("U", d), binding("V", c)]),
            uses([
              proof(
                goal(injective(f)),
                by(fact("composition-of-injective-functions-is-injective.pl", clause(15)))
              ),
              proof(
                goal(app(f, b, d)),
                by(fact("composition-of-injective-functions-is-injective.pl", clause(12)))
              ),
              proof(
                goal(app(f, a, c)),
                by(fact("composition-of-injective-functions-is-injective.pl", clause(11)))
              ),
              proof(
                goal(sameTerm(d, c)),
                by(rule("composition-of-injective-functions-is-injective.pl", clause(10))),
                bindings([binding("Y", d), binding("X", c)]),
                uses([
                  proof(
                    goal(sameTerm(c, d)),
                    by(rule("composition-of-injective-functions-is-injective.pl", clause(19))),
                    bindings([binding("X", c), binding("Y", d), binding("F", g), binding("U", e), binding("V", e)]),
                    uses([
                      proof(
                        goal(injective(g)),
                        by(fact("composition-of-injective-functions-is-injective.pl", clause(16)))
                      ),
                      proof(
                        goal(app(g, c, e)),
                        by(fact("composition-of-injective-functions-is-injective.pl", clause(13)))
                      ),
                      proof(
                        goal(app(g, d, e)),
                        by(fact("composition-of-injective-functions-is-injective.pl", clause(14)))
                      ),
                      proof(
                        goal(sameTerm(e, e)),
                        by(rule("composition-of-injective-functions-is-injective.pl", clause(9))),
                        bindings([binding("X", e)]),
                        uses([
                          proof(
                            goal(inZ(e)),
                            by(fact("composition-of-injective-functions-is-injective.pl", clause(6)))
                          )
                        ])
                      )
                    ])
                  )
                ])
              )
            ])
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

sameInputByCompositeInjectivity(h, b, a).
why(
  sameInputByCompositeInjectivity(h, b, a),
  proof(
    goal(sameInputByCompositeInjectivity(h, b, a)),
    by(rule("composition-of-injective-functions-is-injective.pl", clause(20))),
    bindings([binding("H", h), binding("X", b), binding("Y", a), binding("G", g), binding("F", f), binding("Z", e)]),
    uses([
      proof(
        goal(compositeOf(h, g, f)),
        by(fact("composition-of-injective-functions-is-injective.pl", clause(17)))
      ),
      proof(
        goal(injective(g)),
        by(fact("composition-of-injective-functions-is-injective.pl", clause(16)))
      ),
      proof(
        goal(injective(f)),
        by(fact("composition-of-injective-functions-is-injective.pl", clause(15)))
      ),
      proof(
        goal(app(h, b, e)),
        by(rule("composition-of-injective-functions-is-injective.pl", clause(18))),
        bindings([binding("H", h), binding("X", b), binding("Z", e), binding("G", g), binding("F", f), binding("Y", d)]),
        uses([
          proof(
            goal(compositeOf(h, g, f)),
            by(fact("composition-of-injective-functions-is-injective.pl", clause(17)))
          ),
          proof(
            goal(app(f, b, d)),
            by(fact("composition-of-injective-functions-is-injective.pl", clause(12)))
          ),
          proof(
            goal(app(g, d, e)),
            by(fact("composition-of-injective-functions-is-injective.pl", clause(14)))
          )
        ])
      ),
      proof(
        goal(app(h, a, e)),
        by(rule("composition-of-injective-functions-is-injective.pl", clause(18))),
        bindings([binding("H", h), binding("X", a), binding("Z", e), binding("G", g), binding("F", f), binding("Y", c)]),
        uses([
          proof(
            goal(compositeOf(h, g, f)),
            by(fact("composition-of-injective-functions-is-injective.pl", clause(17)))
          ),
          proof(
            goal(app(f, a, c)),
            by(fact("composition-of-injective-functions-is-injective.pl", clause(11)))
          ),
          proof(
            goal(app(g, c, e)),
            by(fact("composition-of-injective-functions-is-injective.pl", clause(13)))
          )
        ])
      ),
      proof(
        goal(sameTerm(b, a)),
        by(rule("composition-of-injective-functions-is-injective.pl", clause(10))),
        bindings([binding("Y", b), binding("X", a)]),
        uses([
          proof(
            goal(sameTerm(a, b)),
            by(rule("composition-of-injective-functions-is-injective.pl", clause(19))),
            bindings([binding("X", a), binding("Y", b), binding("F", f), binding("U", c), binding("V", d)]),
            uses([
              proof(
                goal(injective(f)),
                by(fact("composition-of-injective-functions-is-injective.pl", clause(15)))
              ),
              proof(
                goal(app(f, a, c)),
                by(fact("composition-of-injective-functions-is-injective.pl", clause(11)))
              ),
              proof(
                goal(app(f, b, d)),
                by(fact("composition-of-injective-functions-is-injective.pl", clause(12)))
              ),
              proof(
                goal(sameTerm(c, d)),
                by(rule("composition-of-injective-functions-is-injective.pl", clause(10))),
                bindings([binding("Y", c), binding("X", d)]),
                uses([
                  proof(
                    goal(sameTerm(d, c)),
                    by(rule("composition-of-injective-functions-is-injective.pl", clause(19))),
                    bindings([binding("X", d), binding("Y", c), binding("F", g), binding("U", e), binding("V", e)]),
                    uses([
                      proof(
                        goal(injective(g)),
                        by(fact("composition-of-injective-functions-is-injective.pl", clause(16)))
                      ),
                      proof(
                        goal(app(g, d, e)),
                        by(fact("composition-of-injective-functions-is-injective.pl", clause(14)))
                      ),
                      proof(
                        goal(app(g, c, e)),
                        by(fact("composition-of-injective-functions-is-injective.pl", clause(13)))
                      ),
                      proof(
                        goal(sameTerm(e, e)),
                        by(rule("composition-of-injective-functions-is-injective.pl", clause(9))),
                        bindings([binding("X", e)]),
                        uses([
                          proof(
                            goal(inZ(e)),
                            by(fact("composition-of-injective-functions-is-injective.pl", clause(6)))
                          )
                        ])
                      )
                    ])
                  )
                ])
              )
            ])
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

