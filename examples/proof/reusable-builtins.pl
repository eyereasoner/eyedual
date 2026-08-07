report(normalized_name, 'ada lovelace').
why(
  report(normalized_name, 'ada lovelace'),
  proof(
    goal(report(normalized_name, 'ada lovelace')),
    by(rule("reusable-builtins.pl", clause(4))),
    bindings([binding("Name", 'ada lovelace'), binding("Raw", '  Ada Lovelace  '), binding("Trimmed", 'Ada Lovelace')]),
    uses([
      proof(
        goal(name_raw('  Ada Lovelace  ')),
        by(fact("reusable-builtins.pl", clause(1)))
      ),
      proof(
        goal(trim('  Ada Lovelace  ', 'Ada Lovelace')),
        by(library(trim, 2))
      ),
      proof(
        goal(lowercase('Ada Lovelace', 'ada lovelace')),
        by(library(lowercase, 2))
      )
    ])
  )
).

report(unique_tags, [logic, math, programming]).
why(
  report(unique_tags, [logic, math, programming]),
  proof(
    goal(report(unique_tags, [logic, math, programming])),
    by(rule("reusable-builtins.pl", clause(5))),
    bindings([binding("Tags", [logic, math, programming]), binding("Csv", 'logic,math,logic,programming'), binding("Parts", [logic, math, logic, programming])]),
    uses([
      proof(
        goal(tag_csv('logic,math,logic,programming')),
        by(fact("reusable-builtins.pl", clause(2)))
      ),
      proof(
        goal(split('logic,math,logic,programming', ',', [logic, math, logic, programming])),
        by(library(split, 3))
      ),
      proof(
        goal(list_to_set([logic, math, logic, programming], [logic, math, programming])),
        by(library(list_to_set, 2))
      )
    ])
  )
).

report(tag_label, 'logic / math / programming').
why(
  report(tag_label, 'logic / math / programming'),
  proof(
    goal(report(tag_label, 'logic / math / programming')),
    by(rule("reusable-builtins.pl", clause(6))),
    bindings([binding("Label", 'logic / math / programming'), binding("Csv", 'logic,math,logic,programming'), binding("Parts", [logic, math, logic, programming]), binding("Tags", [logic, math, programming])]),
    uses([
      proof(
        goal(tag_csv('logic,math,logic,programming')),
        by(fact("reusable-builtins.pl", clause(2)))
      ),
      proof(
        goal(split('logic,math,logic,programming', ',', [logic, math, logic, programming])),
        by(library(split, 3))
      ),
      proof(
        goal(list_to_set([logic, math, logic, programming], [logic, math, programming])),
        by(library(list_to_set, 2))
      ),
      proof(
        goal(join([logic, math, programming], ' / ', 'logic / math / programming')),
        by(library(join, 3))
      )
    ])
  )
).

report(score_summary, summary(42, 21, 6.4807406984078604)).
why(
  report(score_summary, summary(42, 21, 6.4807406984078604)),
  proof(
    goal(report(score_summary, summary(42, 21, 6.4807406984078604))),
    by(rule("reusable-builtins.pl", clause(7))),
    bindings([binding("Total", 42), binding("Peak", 21), binding("Roottotal", 6.4807406984078604), binding("Scores", [8, 13, 21])]),
    uses([
      proof(
        goal(scores([8, 13, 21])),
        by(fact("reusable-builtins.pl", clause(3)))
      ),
      proof(
        goal(sum_list([8, 13, 21], 42)),
        by(library(sum_list, 2))
      ),
      proof(
        goal(max_list([8, 13, 21], 21)),
        by(library(max_list, 2))
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
    by(rule("reusable-builtins.pl", clause(8))),
    bindings([binding("Slice", [13, 21]), binding("Scores", [8, 13, 21])]),
    uses([
      proof(
        goal(scores([8, 13, 21])),
        by(fact("reusable-builtins.pl", clause(3)))
      ),
      proof(
        goal(slice(1, 2, [8, 13, 21], [13, 21])),
        by(library(slice, 4))
      )
    ])
  )
).

