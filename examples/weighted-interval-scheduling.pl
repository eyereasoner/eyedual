% Weighted interval scheduling via automatically tabled dynamic programming.
%
% Intervals are ordered by finish time.  best_from(I,Best) compares the two
% choices at position I: skip it, or take it and jump to the next compatible
% interval.  chosen_from/2 then walks the cached decisions to report a schedule.
query(weighted_interval_answer(X0, X1)).


last_interval(8).
sentinel(9).

interval(1, 1, 4, 5).
interval(2, 3, 5, 1).
interval(3, 0, 6, 8).
interval(4, 4, 7, 4).
interval(5, 3, 9, 6).
interval(6, 5, 9, 3).
interval(7, 6, 10, 2).
interval(8, 8, 11, 4).

% Find the earliest later interval whose start is not before I's finish.
next_compatible(I, J) :-
  interval(I, _start, Finish, _value),
  aggregate_min(K, K,
    (interval(K, Startk, _finishk, _valuek), (K > I), (Startk >= Finish)),
    J, J).
next_compatible(I, 9) :-
  interval(I, _start, Finish, _value),
  \+ (interval(K, Startk, _finishk, _valuek), (K > I), (Startk >= Finish)).

best_from(9, 0).
best_from(I, Best) :-
  last_interval(Last),
  (I =< Last),
  (Next is I + 1),
  best_from(Next, Skip),
  next_compatible(I, Compatible),
  best_from(Compatible, Tail),
  interval(I, _start, _finish, Value),
  (Take is Value + Tail),
  max(Take, Skip, Best).

% Reconstruction emits an interval when the take branch matches the optimal value.
chosen_from(I, I) :-
  best_from(I, Best),
  (Next is I + 1),
  best_from(Next, Skip),
  next_compatible(I, Compatible),
  best_from(Compatible, Tail),
  interval(I, _start, _finish, Value),
  (Take is Value + Tail),
  (Best = Take),
  (Take >= Skip).
chosen_from(I, Chosen) :-
  best_from(I, Best),
  (Next is I + 1),
  best_from(Next, Skip),
  next_compatible(I, Compatible),
  best_from(Compatible, Tail),
  interval(I, _start, _finish, Value),
  (Take is Value + Tail),
  (Best = Take),
  (Take >= Skip),
  chosen_from(Compatible, Chosen).
chosen_from(I, Chosen) :-
  best_from(I, Best),
  (Next is I + 1),
  best_from(Next, Skip),
  next_compatible(I, Compatible),
  best_from(Compatible, Tail),
  interval(I, _start, _finish, Value),
  (Take is Value + Tail),
  (Skip > Take),
  chosen_from(Next, Chosen).

weighted_interval_answer(best_value, Best) :- best_from(1, Best).
weighted_interval_answer(chosen_interval, interval(I, Start, Finish, Value)) :-
  chosen_from(1, I),
  interval(I, Start, Finish, Value).
weighted_interval_answer(candidate_count, Count) :- countall(interval(_i, _start, _finish, _value), Count).
