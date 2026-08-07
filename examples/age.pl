% Age checker adapted from Eyeling.
% The example combines date literals, ISO-8601 duration values, an explicit
% local_time/1 fact, difference/3, and duration comparison. Declaring the date
% as scenario data keeps the result reproducible across hosts and runs.

%% goal: birthDay(X0, X1)

%% goal: duration(X0, X1)

%% goal: ageAbove(X0, X1)

%% goal: holds_result(X0, X1)


birthDay(patH, '1944-08-21').
duration(check, 'P80Y').
local_time('2026-05-30').

% A person is above a duration if the declared local date minus the birthday
% is greater than that duration.
ageAbove(S, A) :-
  birthDay(S, B),
  duration(check, A),
  local_time(D),
  difference(D, B, F),
  (F @> A).

% Test mirroring the Eyeling example.
holds_result(test, true) :-
  ageAbove(_, 'P80Y').
