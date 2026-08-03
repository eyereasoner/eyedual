% ISO dynamic predicates used as a small, explicitly stateful work queue.
%
% Dynamic updates are ordered side effects. This example performs every update
% inside one initialization goal so the later queries observe a stable state.
:- dynamic(task/2).
:- initialization(prepare_queue).

%% goal: report(X0, X1)


task(old_probe, obsolete).

prepare_queue :-
  retract(task(old_probe, obsolete)),
  asserta(task(check_power, urgent)),
  assertz(task(check_network, normal)),
  assertz(task(archive_logs, low)).

report(next_task, Task) :-
  once(task(Task, _)).

report(all_tasks, Tasks) :-
  findall(task(Task, Priority), task(Task, Priority), Tasks).

report(old_task_removed, yes) :-
  \+ task(old_probe, obsolete).

report(dynamic_predicate, yes) :-
  current_predicate(task/2).
