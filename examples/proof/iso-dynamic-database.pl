report(next_task, check_power).
why(
  report(next_task, check_power),
  proof(
    goal(report(next_task, check_power)),
    by(rule("iso-dynamic-database.pl", clause(5))),
    bindings([binding("Task", check_power), binding("__anon0", urgent)]),
    uses([
      proof(
        goal(once(task(check_power, urgent))),
        by(builtin(once, 1)),
        uses([
          proof(
            goal(task(check_power, urgent)),
            by(fact("<input>", clause(8)))
          )
        ])
      )
    ])
  )
).

report(all_tasks, [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)]).
why(
  report(all_tasks, [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)]),
  proof(
    goal(report(all_tasks, [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)])),
    by(rule("iso-dynamic-database.pl", clause(6))),
    bindings([binding("Tasks", [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)])]),
    uses([
      proof(
        goal(findall(task(Task, Priority), task(Task, Priority), [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)])),
        by(builtin(findall, 3))
      )
    ])
  )
).

report(old_task_removed, yes).
why(
  report(old_task_removed, yes),
  proof(
    goal(report(old_task_removed, yes)),
    by(rule("iso-dynamic-database.pl", clause(7))),
    uses([
      proof(
        goal('\\+'(task(old_probe, obsolete))),
        by(builtin('\\+', 1))
      )
    ])
  )
).

report(dynamic_predicate, yes).
why(
  report(dynamic_predicate, yes),
  proof(
    goal(report(dynamic_predicate, yes)),
    by(rule("iso-dynamic-database.pl", clause(8))),
    uses([
      proof(
        goal(current_predicate(/(task, 2))),
        by(builtin(current_predicate, 1))
      )
    ])
  )
).

