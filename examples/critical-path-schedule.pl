% Critical-path scheduling for a small project network.
%
% earliest_start/2 is the maximum finish time over all predecessors; finish_time/2
% adds task duration.  Critical tasks are reconstructed by following predecessors
% that attain those maxima.  Memoization lets the schedule, finish date, and path
% queries share the same project-network subproblems.
query(critical_path_answer(X0, X1)).


% Durations are in arbitrary project time units.
task(requirements, 2).
task(architecture, 3).
task(api_design, 2).
task(database, 4).
task(backend, 6).
task(frontend, 5).
task(auth, 3).
task(integration, 4).
task(security_review, 3).
task(load_test, 2).
task(launch, 1).

depends(architecture, requirements).
depends(api_design, requirements).
depends(database, architecture).
depends(backend, api_design).
depends(backend, database).
depends(frontend, api_design).
depends(auth, architecture).
depends(integration, backend).
depends(integration, frontend).
depends(integration, auth).
depends(security_review, integration).
depends(load_test, integration).
depends(launch, security_review).
depends(launch, load_test).

earliest_start(Task, 0) :-
  task(Task, _duration),
  \+ depends(Task, _pred).
earliest_start(Task, Start) :-
  depends(Task, _pred),
  aggregate_max(Finish, Pred,
    (depends(Task, Pred), finish_time(Pred, Finish)),
    Start, _criticalpred).

finish_time(Task, Finish) :-
  task(Task, Duration),
  earliest_start(Task, Start),
  (Finish is Start + Duration).

% For each task, choose a predecessor that determines its earliest start.
critical_predecessor(Task, Pred) :-
  depends(Task, _anypred),
  aggregate_max(Finish, P,
    (depends(Task, P), finish_time(P, Finish)),
    _bestfinish, Pred).

project_finish(Finish) :-
  aggregate_max(Finishtime, Task, finish_time(Task, Finishtime), Finish, _lasttask).

final_task(Task) :-
  project_finish(Finish),
  finish_time(Task, Finish).

critical_chain(Task, Task).
critical_chain(Task, Pred) :-
  critical_predecessor(Task, Parent),
  critical_chain(Parent, Pred).

critical_task(Task) :-
  final_task(Final),
  critical_chain(Final, Task).

critical_path_answer(project_finish, Finish) :- project_finish(Finish).
critical_path_answer(critical_task, Task) :- critical_task(Task).
critical_path_answer(schedule, task(Task, Start, Finish)) :-
  task(Task, _duration),
  earliest_start(Task, Start),
  finish_time(Task, Finish).
