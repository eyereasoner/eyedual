% Tiny job-shop scheduling benchmark.
%
% Three jobs each require one mill operation and one lathe operation, with fixed
% within-job precedence constraints.  The solver enumerates bounded start times,
% rejects machine overlaps, and uses aggregate_min/5 to keep the minimum makespan.
query(job_shop_answer(X0, X1)).

% Two operations on the same machine are compatible when either one finishes before the other starts.
nonoverlap(_starta, Enda, Startb, _endb) :- (Enda =< Startb).
nonoverlap(Starta, _enda, _startb, Endb) :- (Endb =< Starta).

feasible_schedule(Makespan, [
  op(j1_mill, J1millstart, J1millend),
  op(j1_lathe, J1lathestart, J1latheend),
  op(j2_lathe, J2lathestart, J2latheend),
  op(j2_mill, J2millstart, J2millend),
  op(j3_mill, J3millstart, J3millend),
  op(j3_lathe, J3lathestart, J3latheend)
]) :-
  between(0, 6, J1millstart), (J1millend is J1millstart + 3),
  between(0, 6, J1lathestart), (J1latheend is J1lathestart + 2),
  (J1millend =< J1lathestart),

  between(0, 6, J2lathestart), (J2latheend is J2lathestart + 2),
  between(0, 6, J2millstart), (J2millend is J2millstart + 4),
  (J2latheend =< J2millstart),

  between(0, 6, J3millstart), (J3millend is J3millstart + 2),
  between(0, 6, J3lathestart), (J3latheend is J3lathestart + 3),
  (J3millend =< J3lathestart),

  nonoverlap(J1millstart, J1millend, J2millstart, J2millend),
  nonoverlap(J1millstart, J1millend, J3millstart, J3millend),
  nonoverlap(J2millstart, J2millend, J3millstart, J3millend),
  nonoverlap(J1lathestart, J1latheend, J2lathestart, J2latheend),
  nonoverlap(J1lathestart, J1latheend, J3lathestart, J3latheend),
  nonoverlap(J2lathestart, J2latheend, J3lathestart, J3latheend),

  max(J1latheend, J2millend, Partialmakespan),
  max(Partialmakespan, J3latheend, Makespan).

% aggregate_min/5 returns both the best makespan and the schedule that achieved it.
best_schedule(Makespan, Schedule) :-
  aggregate_min(Makespan, Schedule, feasible_schedule(Makespan, Schedule), Makespan, Schedule).

job_shop_answer(best_makespan, Makespan) :- best_schedule(Makespan, _schedule).
job_shop_answer(best_schedule, Schedule) :- best_schedule(_makespan, Schedule).
job_shop_answer(feasible_schedule_count, Count) :- countall(feasible_schedule(_makespan, _schedule), Count).
