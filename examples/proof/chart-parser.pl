chart_parser_answer(parsed, command).
why(
  chart_parser_answer(parsed, command),
  proof(
    goal(chart_parser_answer(parsed, command)),
    by(rule("chart-parser.pl", clause(31))),
    bindings([binding("Sentence", command), binding("Length", 5)]),
    uses([
      proof(
        goal(sentence(command, 5)),
        by(fact("chart-parser.pl", clause(1)))
      ),
      proof(
        goal(span(command, s, 0, 5)),
        by(rule("chart-parser.pl", clause(30))),
        bindings([binding("Sentence", command), binding("Category", s), binding("Start", 0), binding("End", 5), binding("Left", np), binding("Right", vp), binding("Middle", 2)]),
        uses([
          proof(
            goal(rule(s, np, vp)),
            by(fact("chart-parser.pl", clause(23)))
          ),
          proof(
            goal(span(command, np, 0, 2)),
            by(rule("chart-parser.pl", clause(30))),
            bindings([binding("Sentence", command), binding("Category", np), binding("Start", 0), binding("End", 2), binding("Left", det), binding("Right", noun), binding("Middle", 1)]),
            uses([
              proof(
                goal(rule(np, det, noun)),
                by(fact("chart-parser.pl", clause(24)))
              ),
              proof(
                goal(span(command, det, 0, 1)),
                by(rule("chart-parser.pl", clause(29))),
                bindings([binding("Sentence", command), binding("Category", det), binding("Start", 0), binding("End", 1), binding("Token", the)]),
                uses([
                  proof(
                    goal(word(command, 0, the)),
                    by(fact("chart-parser.pl", clause(3)))
                  ),
                  proof(
                    goal(terminal(det, the)),
                    by(fact("chart-parser.pl", clause(16)))
                  ),
                  proof(
                    goal(is(1, '+'(0, 1))),
                    by(builtin(is, 2))
                  )
                ])
              ),
              proof(
                goal(span(command, noun, 1, 2)),
                by(rule("chart-parser.pl", clause(29))),
                bindings([binding("Sentence", command), binding("Category", noun), binding("Start", 1), binding("End", 2), binding("Token", robot)]),
                uses([
                  proof(
                    goal(word(command, 1, robot)),
                    by(fact("chart-parser.pl", clause(4)))
                  ),
                  proof(
                    goal(terminal(noun, robot)),
                    by(fact("chart-parser.pl", clause(17)))
                  ),
                  proof(
                    goal(is(2, '+'(1, 1))),
                    by(builtin(is, 2))
                  )
                ])
              )
            ])
          ),
          proof(
            goal(span(command, vp, 2, 5)),
            by(rule("chart-parser.pl", clause(30))),
            bindings([binding("Sentence", command), binding("Category", vp), binding("Start", 2), binding("End", 5), binding("Left", verb), binding("Right", np), binding("Middle", 3)]),
            uses([
              proof(
                goal(rule(vp, verb, np)),
                by(fact("chart-parser.pl", clause(26)))
              ),
              proof(
                goal(span(command, verb, 2, 3)),
                by(rule("chart-parser.pl", clause(29))),
                bindings([binding("Sentence", command), binding("Category", verb), binding("Start", 2), binding("End", 3), binding("Token", moves)]),
                uses([
                  proof(
                    goal(word(command, 2, moves)),
                    by(fact("chart-parser.pl", clause(5)))
                  ),
                  proof(
                    goal(terminal(verb, moves)),
                    by(fact("chart-parser.pl", clause(20)))
                  ),
                  proof(
                    goal(is(3, '+'(2, 1))),
                    by(builtin(is, 2))
                  )
                ])
              ),
              proof(
                goal(span(command, np, 3, 5)),
                by(rule("chart-parser.pl", clause(30))),
                bindings([binding("Sentence", command), binding("Category", np), binding("Start", 3), binding("End", 5), binding("Left", det), binding("Right", noun), binding("Middle", 4)]),
                uses([
                  proof(
                    goal(rule(np, det, noun)),
                    by(fact("chart-parser.pl", clause(24)))
                  ),
                  proof(
                    goal(span(command, det, 3, 4)),
                    by(rule("chart-parser.pl", clause(29))),
                    bindings([binding("Sentence", command), binding("Category", det), binding("Start", 3), binding("End", 4), binding("Token", the)]),
                    uses([
                      proof(
                        goal(word(command, 3, the)),
                        by(fact("chart-parser.pl", clause(6)))
                      ),
                      proof(
                        goal(terminal(det, the)),
                        by(fact("chart-parser.pl", clause(16)))
                      ),
                      proof(
                        goal(is(4, '+'(3, 1))),
                        by(builtin(is, 2))
                      )
                    ])
                  ),
                  proof(
                    goal(span(command, noun, 4, 5)),
                    by(rule("chart-parser.pl", clause(29))),
                    bindings([binding("Sentence", command), binding("Category", noun), binding("Start", 4), binding("End", 5), binding("Token", box)]),
                    uses([
                      proof(
                        goal(word(command, 4, box)),
                        by(fact("chart-parser.pl", clause(7)))
                      ),
                      proof(
                        goal(terminal(noun, box)),
                        by(fact("chart-parser.pl", clause(18)))
                      ),
                      proof(
                        goal(is(5, '+'(4, 1))),
                        by(builtin(is, 2))
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
  )
).

chart_parser_answer(parsed, ambiguous_pp).
why(
  chart_parser_answer(parsed, ambiguous_pp),
  proof(
    goal(chart_parser_answer(parsed, ambiguous_pp)),
    by(rule("chart-parser.pl", clause(31))),
    bindings([binding("Sentence", ambiguous_pp), binding("Length", 8)]),
    uses([
      proof(
        goal(sentence(ambiguous_pp, 8)),
        by(fact("chart-parser.pl", clause(2)))
      ),
      proof(
        goal(span(ambiguous_pp, s, 0, 8)),
        by(rule("chart-parser.pl", clause(30))),
        bindings([binding("Sentence", ambiguous_pp), binding("Category", s), binding("Start", 0), binding("End", 8), binding("Left", np), binding("Right", vp), binding("Middle", 2)]),
        uses([
          proof(
            goal(rule(s, np, vp)),
            by(fact("chart-parser.pl", clause(23)))
          ),
          proof(
            goal(span(ambiguous_pp, np, 0, 2)),
            by(rule("chart-parser.pl", clause(30))),
            bindings([binding("Sentence", ambiguous_pp), binding("Category", np), binding("Start", 0), binding("End", 2), binding("Left", det), binding("Right", noun), binding("Middle", 1)]),
            uses([
              proof(
                goal(rule(np, det, noun)),
                by(fact("chart-parser.pl", clause(24)))
              ),
              proof(
                goal(span(ambiguous_pp, det, 0, 1)),
                by(rule("chart-parser.pl", clause(29))),
                bindings([binding("Sentence", ambiguous_pp), binding("Category", det), binding("Start", 0), binding("End", 1), binding("Token", the)]),
                uses([
                  proof(
                    goal(word(ambiguous_pp, 0, the)),
                    by(fact("chart-parser.pl", clause(8)))
                  ),
                  proof(
                    goal(terminal(det, the)),
                    by(fact("chart-parser.pl", clause(16)))
                  ),
                  proof(
                    goal(is(1, '+'(0, 1))),
                    by(builtin(is, 2))
                  )
                ])
              ),
              proof(
                goal(span(ambiguous_pp, noun, 1, 2)),
                by(rule("chart-parser.pl", clause(29))),
                bindings([binding("Sentence", ambiguous_pp), binding("Category", noun), binding("Start", 1), binding("End", 2), binding("Token", robot)]),
                uses([
                  proof(
                    goal(word(ambiguous_pp, 1, robot)),
                    by(fact("chart-parser.pl", clause(9)))
                  ),
                  proof(
                    goal(terminal(noun, robot)),
                    by(fact("chart-parser.pl", clause(17)))
                  ),
                  proof(
                    goal(is(2, '+'(1, 1))),
                    by(builtin(is, 2))
                  )
                ])
              )
            ])
          ),
          proof(
            goal(span(ambiguous_pp, vp, 2, 8)),
            by(rule("chart-parser.pl", clause(30))),
            bindings([binding("Sentence", ambiguous_pp), binding("Category", vp), binding("Start", 2), binding("End", 8), binding("Left", verb), binding("Right", np), binding("Middle", 3)]),
            uses([
              proof(
                goal(rule(vp, verb, np)),
                by(fact("chart-parser.pl", clause(26)))
              ),
              proof(
                goal(span(ambiguous_pp, verb, 2, 3)),
                by(rule("chart-parser.pl", clause(29))),
                bindings([binding("Sentence", ambiguous_pp), binding("Category", verb), binding("Start", 2), binding("End", 3), binding("Token", sees)]),
                uses([
                  proof(
                    goal(word(ambiguous_pp, 2, sees)),
                    by(fact("chart-parser.pl", clause(10)))
                  ),
                  proof(
                    goal(terminal(verb, sees)),
                    by(fact("chart-parser.pl", clause(21)))
                  ),
                  proof(
                    goal(is(3, '+'(2, 1))),
                    by(builtin(is, 2))
                  )
                ])
              ),
              proof(
                goal(span(ambiguous_pp, np, 3, 8)),
                by(rule("chart-parser.pl", clause(30))),
                bindings([binding("Sentence", ambiguous_pp), binding("Category", np), binding("Start", 3), binding("End", 8), binding("Left", np), binding("Right", pp), binding("Middle", 5)]),
                uses([
                  proof(
                    goal(rule(np, np, pp)),
                    by(fact("chart-parser.pl", clause(25)))
                  ),
                  proof(
                    goal(span(ambiguous_pp, np, 3, 5)),
                    by(rule("chart-parser.pl", clause(30))),
                    bindings([binding("Sentence", ambiguous_pp), binding("Category", np), binding("Start", 3), binding("End", 5), binding("Left", det), binding("Right", noun), binding("Middle", 4)]),
                    uses([
                      proof(
                        goal(rule(np, det, noun)),
                        by(fact("chart-parser.pl", clause(24)))
                      ),
                      proof(
                        goal(span(ambiguous_pp, det, 3, 4)),
                        by(rule("chart-parser.pl", clause(29))),
                        bindings([binding("Sentence", ambiguous_pp), binding("Category", det), binding("Start", 3), binding("End", 4), binding("Token", the)]),
                        uses([
                          proof(
                            goal(word(ambiguous_pp, 3, the)),
                            by(fact("chart-parser.pl", clause(11)))
                          ),
                          proof(
                            goal(terminal(det, the)),
                            by(fact("chart-parser.pl", clause(16)))
                          ),
                          proof(
                            goal(is(4, '+'(3, 1))),
                            by(builtin(is, 2))
                          )
                        ])
                      ),
                      proof(
                        goal(span(ambiguous_pp, noun, 4, 5)),
                        by(rule("chart-parser.pl", clause(29))),
                        bindings([binding("Sentence", ambiguous_pp), binding("Category", noun), binding("Start", 4), binding("End", 5), binding("Token", box)]),
                        uses([
                          proof(
                            goal(word(ambiguous_pp, 4, box)),
                            by(fact("chart-parser.pl", clause(12)))
                          ),
                          proof(
                            goal(terminal(noun, box)),
                            by(fact("chart-parser.pl", clause(18)))
                          ),
                          proof(
                            goal(is(5, '+'(4, 1))),
                            by(builtin(is, 2))
                          )
                        ])
                      )
                    ])
                  ),
                  proof(
                    goal(span(ambiguous_pp, pp, 5, 8)),
                    by(rule("chart-parser.pl", clause(30))),
                    bindings([binding("Sentence", ambiguous_pp), binding("Category", pp), binding("Start", 5), binding("End", 8), binding("Left", prep), binding("Right", np), binding("Middle", 6)]),
                    uses([
                      proof(
                        goal(rule(pp, prep, np)),
                        by(fact("chart-parser.pl", clause(28)))
                      ),
                      proof(
                        goal(span(ambiguous_pp, prep, 5, 6)),
                        by(rule("chart-parser.pl", clause(29))),
                        bindings([binding("Sentence", ambiguous_pp), binding("Category", prep), binding("Start", 5), binding("End", 6), binding("Token", with)]),
                        uses([
                          proof(
                            goal(word(ambiguous_pp, 5, with)),
                            by(fact("chart-parser.pl", clause(13)))
                          ),
                          proof(
                            goal(terminal(prep, with)),
                            by(fact("chart-parser.pl", clause(22)))
                          ),
                          proof(
                            goal(is(6, '+'(5, 1))),
                            by(builtin(is, 2))
                          )
                        ])
                      ),
                      proof(
                        goal(span(ambiguous_pp, np, 6, 8)),
                        by(rule("chart-parser.pl", clause(30))),
                        bindings([binding("Sentence", ambiguous_pp), binding("Category", np), binding("Start", 6), binding("End", 8), binding("Left", det), binding("Right", noun), binding("Middle", 7)]),
                        uses([
                          proof(
                            goal(rule(np, det, noun)),
                            by(fact("chart-parser.pl", clause(24)))
                          ),
                          proof(
                            goal(span(ambiguous_pp, det, 6, 7)),
                            by(rule("chart-parser.pl", clause(29))),
                            bindings([binding("Sentence", ambiguous_pp), binding("Category", det), binding("Start", 6), binding("End", 7), binding("Token", the)]),
                            uses([
                              proof(
                                goal(word(ambiguous_pp, 6, the)),
                                by(fact("chart-parser.pl", clause(14)))
                              ),
                              proof(
                                goal(terminal(det, the)),
                                by(fact("chart-parser.pl", clause(16)))
                              ),
                              proof(
                                goal(is(7, '+'(6, 1))),
                                by(builtin(is, 2))
                              )
                            ])
                          ),
                          proof(
                            goal(span(ambiguous_pp, noun, 7, 8)),
                            by(rule("chart-parser.pl", clause(29))),
                            bindings([binding("Sentence", ambiguous_pp), binding("Category", noun), binding("Start", 7), binding("End", 8), binding("Token", telescope)]),
                            uses([
                              proof(
                                goal(word(ambiguous_pp, 7, telescope)),
                                by(fact("chart-parser.pl", clause(15)))
                              ),
                              proof(
                                goal(terminal(noun, telescope)),
                                by(fact("chart-parser.pl", clause(19)))
                              ),
                              proof(
                                goal(is(8, '+'(7, 1))),
                                by(builtin(is, 2))
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
          )
        ])
      )
    ])
  )
).

chart_parser_answer(parse_count, count(command, 1)).
why(
  chart_parser_answer(parse_count, count(command, 1)),
  proof(
    goal(chart_parser_answer(parse_count, count(command, 1))),
    by(rule("chart-parser.pl", clause(32))),
    bindings([binding("Sentence", command), binding("Count", 1), binding("Length", 5)]),
    uses([
      proof(
        goal(sentence(command, 5)),
        by(fact("chart-parser.pl", clause(1)))
      ),
      proof(
        goal(countall(span(command, s, 0, 5), 1)),
        by(library(countall, 2))
      )
    ])
  )
).

chart_parser_answer(parse_count, count(ambiguous_pp, 1)).
why(
  chart_parser_answer(parse_count, count(ambiguous_pp, 1)),
  proof(
    goal(chart_parser_answer(parse_count, count(ambiguous_pp, 1))),
    by(rule("chart-parser.pl", clause(32))),
    bindings([binding("Sentence", ambiguous_pp), binding("Count", 1), binding("Length", 8)]),
    uses([
      proof(
        goal(sentence(ambiguous_pp, 8)),
        by(fact("chart-parser.pl", clause(2)))
      ),
      proof(
        goal(countall(span(ambiguous_pp, s, 0, 8), 1)),
        by(library(countall, 2))
      )
    ])
  )
).

chart_parser_answer(noun_phrase_count, count(command, 2)).
why(
  chart_parser_answer(noun_phrase_count, count(command, 2)),
  proof(
    goal(chart_parser_answer(noun_phrase_count, count(command, 2))),
    by(rule("chart-parser.pl", clause(33))),
    bindings([binding("Sentence", command), binding("Count", 2), binding("Length", 5)]),
    uses([
      proof(
        goal(sentence(command, 5)),
        by(fact("chart-parser.pl", clause(1)))
      ),
      proof(
        goal(countall(span(command, np, _start, _end), 2)),
        by(library(countall, 2))
      ),
      proof(
        goal(>(5, 0)),
        by(builtin(>, 2))
      )
    ])
  )
).

chart_parser_answer(noun_phrase_count, count(ambiguous_pp, 4)).
why(
  chart_parser_answer(noun_phrase_count, count(ambiguous_pp, 4)),
  proof(
    goal(chart_parser_answer(noun_phrase_count, count(ambiguous_pp, 4))),
    by(rule("chart-parser.pl", clause(33))),
    bindings([binding("Sentence", ambiguous_pp), binding("Count", 4), binding("Length", 8)]),
    uses([
      proof(
        goal(sentence(ambiguous_pp, 8)),
        by(fact("chart-parser.pl", clause(2)))
      ),
      proof(
        goal(countall(span(ambiguous_pp, np, _start, _end), 4)),
        by(library(countall, 2))
      ),
      proof(
        goal(>(8, 0)),
        by(builtin(>, 2))
      )
    ])
  )
).

