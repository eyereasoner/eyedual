report(normalized_name, "ada lovelace").
why(
  report(normalized_name, "ada lovelace"),
  proof(
    goal(report(normalized_name, "ada lovelace")),
    by(rule("reusable-builtins.pl", clause(5))),
    bindings([binding("Name", "ada lovelace"), binding("Raw", "  Ada Lovelace  "), binding("Trimmed", "Ada Lovelace")]),
    uses([
      proof(
        goal(name_raw("  Ada Lovelace  ")),
        by(fact("reusable-builtins.pl", clause(2)))
      ),
      proof(
        goal(trim("  Ada Lovelace  ", "Ada Lovelace")),
        by(builtin(trim, 2))
      ),
      proof(
        goal(lowercase("Ada Lovelace", "ada lovelace")),
        by(builtin(lowercase, 2))
      )
    ])
  )
).

report(unique_tags, ["logic", "math", "programming"]).
why(
  report(unique_tags, ["logic", "math", "programming"]),
  proof(
    goal(report(unique_tags, ["logic", "math", "programming"])),
    by(rule("reusable-builtins.pl", clause(6))),
    bindings([binding("Tags", ["logic", "math", "programming"]), binding("Csv", "logic,math,logic,programming"), binding("Parts", ["logic", "math", "logic", "programming"])]),
    uses([
      proof(
        goal(tag_csv("logic,math,logic,programming")),
        by(fact("reusable-builtins.pl", clause(3)))
      ),
      proof(
        goal(split("logic,math,logic,programming", ",", ["logic", "math", "logic", "programming"])),
        by(builtin(split, 3))
      ),
      proof(
        goal(list_to_set(["logic", "math", "logic", "programming"], ["logic", "math", "programming"])),
        by(rule("<library>", clause(44))),
        bindings([binding("X", "logic"), binding("Xs", ["math", "logic", "programming"]), binding("Set", ["math", "programming"]), binding("Rest", ["math", "programming"])]),
        uses([
          proof(
            goal(findall(Y, (member(Y, ["math", "logic", "programming"]), \==(Y, "logic")), ["math", "programming"])),
            by(builtin(findall, 3))
          ),
          proof(
            goal(list_to_set(["math", "programming"], ["math", "programming"])),
            by(rule("<library>", clause(44))),
            bindings([binding("X", "math"), binding("Xs", ["programming"]), binding("Set", ["programming"]), binding("Rest", ["programming"])]),
            uses([
              proof(
                goal(findall(Y, (member(Y, ["programming"]), \==(Y, "math")), ["programming"])),
                by(builtin(findall, 3))
              ),
              proof(
                goal(list_to_set(["programming"], ["programming"])),
                by(rule("<library>", clause(44))),
                bindings([binding("X", "programming"), binding("Xs", []), binding("Set", []), binding("Rest", [])]),
                uses([
                  proof(
                    goal(findall(Y, (member(Y, []), \==(Y, "programming")), [])),
                    by(builtin(findall, 3))
                  ),
                  proof(
                    goal(list_to_set([], [])),
                    by(fact("<library>", clause(43)))
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

report(tag_label, "logic / math / programming").
why(
  report(tag_label, "logic / math / programming"),
  proof(
    goal(report(tag_label, "logic / math / programming")),
    by(rule("reusable-builtins.pl", clause(7))),
    bindings([binding("Label", "logic / math / programming"), binding("Csv", "logic,math,logic,programming"), binding("Parts", ["logic", "math", "logic", "programming"]), binding("Tags", ["logic", "math", "programming"])]),
    uses([
      proof(
        goal(tag_csv("logic,math,logic,programming")),
        by(fact("reusable-builtins.pl", clause(3)))
      ),
      proof(
        goal(split("logic,math,logic,programming", ",", ["logic", "math", "logic", "programming"])),
        by(builtin(split, 3))
      ),
      proof(
        goal(list_to_set(["logic", "math", "logic", "programming"], ["logic", "math", "programming"])),
        by(rule("<library>", clause(44))),
        bindings([binding("X", "logic"), binding("Xs", ["math", "logic", "programming"]), binding("Set", ["math", "programming"]), binding("Rest", ["math", "programming"])]),
        uses([
          proof(
            goal(findall(Y, (member(Y, ["math", "logic", "programming"]), \==(Y, "logic")), ["math", "programming"])),
            by(builtin(findall, 3))
          ),
          proof(
            goal(list_to_set(["math", "programming"], ["math", "programming"])),
            by(rule("<library>", clause(44))),
            bindings([binding("X", "math"), binding("Xs", ["programming"]), binding("Set", ["programming"]), binding("Rest", ["programming"])]),
            uses([
              proof(
                goal(findall(Y, (member(Y, ["programming"]), \==(Y, "math")), ["programming"])),
                by(builtin(findall, 3))
              ),
              proof(
                goal(list_to_set(["programming"], ["programming"])),
                by(rule("<library>", clause(44))),
                bindings([binding("X", "programming"), binding("Xs", []), binding("Set", []), binding("Rest", [])]),
                uses([
                  proof(
                    goal(findall(Y, (member(Y, []), \==(Y, "programming")), [])),
                    by(builtin(findall, 3))
                  ),
                  proof(
                    goal(list_to_set([], [])),
                    by(fact("<library>", clause(43)))
                  )
                ])
              )
            ])
          )
        ])
      ),
      proof(
        goal(join(["logic", "math", "programming"], " / ", "logic / math / programming")),
        by(rule("<library>", clause(8))),
        bindings([binding("Item", "logic"), binding("Items", ["math", "programming"]), binding("Separator", " / "), binding("Text", "logic / math / programming"), binding("ItemAtom", logic), binding("TextAtom", 'logic / math / programming')]),
        uses([
          proof(
            goal(atom_string(logic, "logic")),
            by(builtin(atom_string, 2))
          ),
          proof(
            goal(join_atoms(["math", "programming"], " / ", logic, 'logic / math / programming')),
            by(rule("<library>", clause(10))),
            bindings([binding("Item", "math"), binding("Items", ["programming"]), binding("Separator", " / "), binding("Acc", logic), binding("Text", 'logic / math / programming'), binding("SeparatorAtom", ' / '), binding("ItemAtom", math), binding("WithSeparator", 'logic / '), binding("Next", 'logic / math')]),
            uses([
              proof(
                goal(atom_string(' / ', " / ")),
                by(builtin(atom_string, 2))
              ),
              proof(
                goal(atom_string(math, "math")),
                by(builtin(atom_string, 2))
              ),
              proof(
                goal(atom_concat(logic, ' / ', 'logic / ')),
                by(builtin(atom_concat, 3))
              ),
              proof(
                goal(atom_concat('logic / ', math, 'logic / math')),
                by(builtin(atom_concat, 3))
              ),
              proof(
                goal(join_atoms(["programming"], " / ", 'logic / math', 'logic / math / programming')),
                by(rule("<library>", clause(10))),
                bindings([binding("Item", "programming"), binding("Items", []), binding("Separator", " / "), binding("Acc", 'logic / math'), binding("Text", 'logic / math / programming'), binding("SeparatorAtom", ' / '), binding("ItemAtom", programming), binding("WithSeparator", 'logic / math / '), binding("Next", 'logic / math / programming')]),
                uses([
                  proof(
                    goal(atom_string(' / ', " / ")),
                    by(builtin(atom_string, 2))
                  ),
                  proof(
                    goal(atom_string(programming, "programming")),
                    by(builtin(atom_string, 2))
                  ),
                  proof(
                    goal(atom_concat('logic / math', ' / ', 'logic / math / ')),
                    by(builtin(atom_concat, 3))
                  ),
                  proof(
                    goal(atom_concat('logic / math / ', programming, 'logic / math / programming')),
                    by(builtin(atom_concat, 3))
                  ),
                  proof(
                    goal(join_atoms([], " / ", 'logic / math / programming', 'logic / math / programming')),
                    by(fact("<library>", clause(9))),
                    bindings([binding("__anon4", " / "), binding("Text", 'logic / math / programming')])
                  )
                ])
              )
            ])
          ),
          proof(
            goal(atom_string('logic / math / programming', "logic / math / programming")),
            by(builtin(atom_string, 2))
          )
        ])
      )
    ])
  )
).

report(score_summary, summary(42, 21, 6.4807406984078604)).
why(
  report(score_summary, summary(42, 21, 6.4807406984078604)),
  proof(
    goal(report(score_summary, summary(42, 21, 6.4807406984078604))),
    by(rule("reusable-builtins.pl", clause(8))),
    bindings([binding("Total", 42), binding("Peak", 21), binding("Roottotal", 6.4807406984078604), binding("Scores", [8, 13, 21])]),
    uses([
      proof(
        goal(scores([8, 13, 21])),
        by(fact("reusable-builtins.pl", clause(4)))
      ),
      proof(
        goal(sum_list([8, 13, 21], 42)),
        by(rule("<library>", clause(35))),
        bindings([binding("X", 8), binding("Xs", [13, 21]), binding("Sum", 42), binding("Tail", 34)]),
        uses([
          proof(
            goal(sum_list([13, 21], 34)),
            by(rule("<library>", clause(35))),
            bindings([binding("X", 13), binding("Xs", [21]), binding("Sum", 34), binding("Tail", 21)]),
            uses([
              proof(
                goal(sum_list([21], 21)),
                by(rule("<library>", clause(35))),
                bindings([binding("X", 21), binding("Xs", []), binding("Sum", 21), binding("Tail", 0)]),
                uses([
                  proof(
                    goal(sum_list([], 0)),
                    by(fact("<library>", clause(34)))
                  ),
                  proof(
                    goal(is(21, '+'(21, 0))),
                    by(builtin(is, 2))
                  )
                ])
              ),
              proof(
                goal(is(34, '+'(13, 21))),
                by(builtin(is, 2))
              )
            ])
          ),
          proof(
            goal(is(42, '+'(8, 34))),
            by(builtin(is, 2))
          )
        ])
      ),
      proof(
        goal(max_list([8, 13, 21], 21)),
        by(rule("<library>", clause(39))),
        bindings([binding("X", 8), binding("Xs", [13, 21]), binding("Max", 21)]),
        uses([
          proof(
            goal(max_list_acc([13, 21], 8, 21)),
            by(rule("<library>", clause(41))),
            bindings([binding("X", 13), binding("Xs", [21]), binding("Acc", 8), binding("Max", 21), binding("Next", 13)]),
            uses([
              proof(
                goal(';'(->(@>(13, 8), =(13, 13)), =(13, 8))),
                by(builtin(';', 2))
              ),
              proof(
                goal(max_list_acc([21], 13, 21)),
                by(rule("<library>", clause(41))),
                bindings([binding("X", 21), binding("Xs", []), binding("Acc", 13), binding("Max", 21), binding("Next", 21)]),
                uses([
                  proof(
                    goal(';'(->(@>(21, 13), =(21, 21)), =(21, 13))),
                    by(builtin(';', 2))
                  ),
                  proof(
                    goal(max_list_acc([], 21, 21)),
                    by(fact("<library>", clause(40))),
                    bindings([binding("Max", 21)])
                  )
                ])
              )
            ])
          )
        ])
      ),
      proof(
        goal(is(6.4807406984078604, sqrt(42))),
        by(builtin(is, 2))
      )
    ])
  )
).

report(window, [13, 21]).
why(
  report(window, [13, 21]),
  proof(
    goal(report(window, [13, 21])),
    by(rule("reusable-builtins.pl", clause(9))),
    bindings([binding("Slice", [13, 21]), binding("Scores", [8, 13, 21])]),
    uses([
      proof(
        goal(scores([8, 13, 21])),
        by(fact("reusable-builtins.pl", clause(4)))
      ),
      proof(
        goal(slice(1, 2, [8, 13, 21], [13, 21])),
        by(rule("<library>", clause(28))),
        bindings([binding("Start", 1), binding("Count", 2), binding("Xs", [8, 13, 21]), binding("Slice", [13, 21]), binding("Suffix", [13, 21])]),
        uses([
          proof(
            goal(drop(1, [8, 13, 21], [13, 21])),
            by(rule("<library>", clause(27))),
            bindings([binding("N", 1), binding("__anon15", 8), binding("Xs", [13, 21]), binding("Ys", [13, 21]), binding("N0", 0)]),
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
                goal(drop(0, [13, 21], [13, 21])),
                by(fact("<library>", clause(26))),
                bindings([binding("Xs", [13, 21])])
              )
            ])
          ),
          proof(
            goal(take(2, [13, 21], [13, 21])),
            by(rule("<library>", clause(25))),
            bindings([binding("N", 2), binding("X", 13), binding("Xs", [21]), binding("Ys", [21]), binding("N0", 1)]),
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
                goal(take(1, [21], [21])),
                by(rule("<library>", clause(25))),
                bindings([binding("N", 1), binding("X", 21), binding("Xs", []), binding("Ys", []), binding("N0", 0)]),
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
                    goal(take(0, [], [])),
                    by(fact("<library>", clause(24))),
                    bindings([binding("__anon14", [])])
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

