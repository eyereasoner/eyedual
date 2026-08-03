% Control Systems example, adapted from Eyelet's input/control-system.pl.
%
% The example combines measurements, observations, targets, logarithmic
% feedforward compensation, square-root normalization, and nonlinear feedback.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%
% Each derived quantity is represented as its own predicate rather than a single
% formula blob, making the proof trace useful for debugging a failed actuator
% normalization or control-signal calculation.
%% goal: controlSignal(X0, X1)

%% goal: status(X0, X1)

%% goal: normalizedMeasurement(X0, X1)

%% goal: log10(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
measurement(input1, [6, 11]).
measurement(disturbance2, [45, 39]).
measurement(input2, true).
measurement(input3, 56967).
measurement(disturbance1, 35766).
measurement(output2, 24).

observation(state1, 80).
observation(state2, false).
observation(state3, 22).

target(output2, 29).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
measurement_normalized(I, M) :-
  measurement(I, [M1, M2]),
  (M1 < M2),
  (Delta is M2 - M1),
  (M is Delta ** 0.5).

measurement_normalized(I, M1) :-
  measurement(I, [M1, M2]),
  (M1 >= M2).

numeric_log10(Value, Result) :-
  (Naturallog is log(Value)),
  (Naturallog10 is log(10)),
  (Result is Naturallog / Naturallog10).

control(actuator1, C) :-
  measurement_normalized(input1, M1),
  measurement(input2, true),
  measurement(disturbance1, D1),
  (Proportional is M1 * 19.6),
  numeric_log10(D1, Compensation),
  (C is Proportional - Compensation).

control(actuator2, C) :-
  observation(state3, P3),
  measurement(output2, M4),
  target(output2, T2),
  (Error is T2 - M4),
  (Differentialerror is P3 - M4),
  (Proportional is 5.8 * Error),
  (Nonlinearfactor is 7.3 / Error),
  (Differential is Nonlinearfactor * Differentialerror),
  (C is Proportional + Differential).

controlSignal(Actuator, C) :-
  control(Actuator, C).

status(Actuator, active) :-
  control(Actuator, _c).

normalizedMeasurement(input1, M) :-
  measurement_normalized(input1, M).

log10(disturbance1, C) :-
  measurement(disturbance1, D),
  numeric_log10(D, C).
