% Science example: simple pendulum period.
%
% For small oscillations, T = 2*pi*sqrt(length / gravity).  Gravity is chosen
% as pi^2 m/s^2 so a one-meter pendulum has a period of two seconds.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: period_s(X0, X1)

%% goal: periodError_s(X0, X1)

%% goal: status(X0, X1)

%% goal: reason(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
constant(pi, 3.141592653589793).
experiment(pendulum1, length_m, 1.0).
experiment(pendulum1, gravity_m_s2, 9.869604401089358).
limit(pendulum1, target_period_s, 2.0).
limit(pendulum1, tolerance_s, 0.01).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
period(Experiment, Period) :-
  experiment(Experiment, length_m, Length),
  experiment(Experiment, gravity_m_s2, Gravity),
  (Ratio is Length / Gravity),
  (Root is Ratio ** 0.5),
  constant(pi, Pi),
  (Twopi is 2.0 * Pi),
  (Period is Twopi * Root).

period_error(Experiment, Error) :-
  period(Experiment, Period),
  limit(Experiment, target_period_s, Target),
  (Rawerror is Period - Target),
  (Error is abs(Rawerror)).

within_period_tolerance(Experiment) :-
  period_error(Experiment, Error),
  limit(Experiment, tolerance_s, Tolerance),
  (Error < Tolerance).

period_s(Experiment, Period) :-
  period(Experiment, Period).

periodError_s(Experiment, Error) :-
  period_error(Experiment, Error).

status(Experiment, within_period_tolerance) :-
  within_period_tolerance(Experiment).

reason(Experiment, "small-angle period matches the two-second target") :-
  within_period_tolerance(Experiment).
