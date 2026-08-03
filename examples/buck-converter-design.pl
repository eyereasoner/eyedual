% Engineering example: buck-converter ripple check.
%
% A simplified continuous-conduction buck converter model computes duty cycle,
% inductor ripple current, capacitor ripple voltage, and checks design limits.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%
% The constants describe one regulator design. The rules intentionally keep
% each engineering equation separate so proof output can point to the exact
% calculation that made the design pass or fail.
%% goal: dutyCycle(X0, X1)

%% goal: inductorRipple_A(X0, X1)

%% goal: rippleRatio(X0, X1)

%% goal: capacitorRipple_V(X0, X1)

%% goal: status(X0, X1)

%% goal: reason(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
converter(regulator1, inputVoltage_V, 24.0).
converter(regulator1, outputVoltage_V, 5.0).
converter(regulator1, loadCurrent_A, 2.0).
converter(regulator1, switchingFrequency_Hz, 500000.0).
converter(regulator1, inductance_H, 0.000022).
converter(regulator1, capacitance_F, 0.000047).
limit(regulator1, maxRippleRatio, 0.30).
limit(regulator1, maxOutputRipple_V, 0.05).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
duty_cycle(Converter, Duty) :-
  converter(Converter, outputVoltage_V, Outputvoltage),
  converter(Converter, inputVoltage_V, Inputvoltage),
  (Duty is Outputvoltage / Inputvoltage).

inductor_ripple_current(Converter, Ripplecurrent) :-
  converter(Converter, inputVoltage_V, Inputvoltage),
  converter(Converter, outputVoltage_V, Outputvoltage),
  converter(Converter, inductance_H, Inductance),
  converter(Converter, switchingFrequency_Hz, Frequency),
  duty_cycle(Converter, Duty),
  (Voltageacrossinductor is Inputvoltage - Outputvoltage),
  (Numerator is Voltageacrossinductor * Duty),
  (Denominator is Inductance * Frequency),
  (Ripplecurrent is Numerator / Denominator).

ripple_ratio(Converter, Ratio) :-
  inductor_ripple_current(Converter, Ripplecurrent),
  converter(Converter, loadCurrent_A, Loadcurrent),
  (Ratio is Ripplecurrent / Loadcurrent).

capacitor_ripple_voltage(Converter, Ripplevoltage) :-
  inductor_ripple_current(Converter, Ripplecurrent),
  converter(Converter, switchingFrequency_Hz, Frequency),
  converter(Converter, capacitance_F, Capacitance),
  (Eightf is 8.0 * Frequency),
  (Denominator is Eightf * Capacitance),
  (Ripplevoltage is Ripplecurrent / Denominator).

% within_ripple_limits/1 is the design gate for ripple current and output voltage.
within_ripple_limits(Converter) :-
  ripple_ratio(Converter, Ratio),
  limit(Converter, maxRippleRatio, Maxratio),
  (Ratio < Maxratio),
  capacitor_ripple_voltage(Converter, Ripplevoltage),
  limit(Converter, maxOutputRipple_V, Maxripplevoltage),
  (Ripplevoltage < Maxripplevoltage).

dutyCycle(Converter, Duty) :-
  duty_cycle(Converter, Duty).

inductorRipple_A(Converter, Ripplecurrent) :-
  inductor_ripple_current(Converter, Ripplecurrent).

rippleRatio(Converter, Ratio) :-
  ripple_ratio(Converter, Ratio).

capacitorRipple_V(Converter, Ripplevoltage) :-
  capacitor_ripple_voltage(Converter, Ripplevoltage).

status(Converter, stable_ripple_design) :-
  within_ripple_limits(Converter).

reason(Converter, "inductor-current and output-voltage ripple are below design limits") :-
  within_ripple_limits(Converter).
