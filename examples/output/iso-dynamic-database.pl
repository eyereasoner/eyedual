report(next_task, check_power).
report(all_tasks, [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)]).
report(old_task_removed, yes).
report(dynamic_predicate, yes).
