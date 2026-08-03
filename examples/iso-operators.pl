% ISO operator declarations as readable surface syntax for ordinary terms.
%
% op/3 changes parsing, not logical meaning: `sensor_7 reports temperature`
% is the compound reports(sensor_7, temperature), which =../2 can expose.
:- op(600, xfx, reports).
:- op(500, xfy, and).

%% goal: report(X0, X1)


sensor_7 reports temperature.
sensor_7 reports humidity.

observations(Sensor, First and Second) :-
  Sensor reports First,
  Sensor reports Second,
  First @< Second.

report(parsed_as, Parts) :-
  ((sensor_7 reports temperature) =.. Parts).

report(observations, Pair) :-
  observations(sensor_7, Pair).

report(operator, operator(Priority, Specifier)) :-
  current_op(Priority, Specifier, reports).
