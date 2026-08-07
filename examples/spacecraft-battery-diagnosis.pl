% Evidence-backed spacecraft battery diagnosis.
%
% This compact engineering model combines telemetry, derived physical
% quantities, threshold checks, redundant sensing, diagnosis, and response.
% The values and limits are illustrative; they are not operational flight
% rules.

%% goal: metric(X0, X1, X2)

%% goal: diagnosis(X0, X1)

%% goal: action(X0, X1)


% Primary telemetry for battery pack bp1.
telemetry(bp1, temperature_c, 78.0).
telemetry(bp1, temperature_rise_c_per_min, 4.2).
telemetry(bp1, current_a, 32.0).
telemetry(bp1, internal_resistance_ohm, 0.015625).
telemetry(bp1, cell_delta_v, 0.19).

% An independent temperature channel provides corroborating evidence.
redundant_telemetry(bp1, temperature_c, 76.0).

% Illustrative engineering limits and available cooling power.
safety_limit(max_safe_temperature_c, 60.0).
safety_limit(max_temperature_rise_c_per_min, 1.5).
safety_limit(max_cell_delta_v, 0.08).
cooling_capacity_w(bp1, 12.0).

% Thermal margin is positive below the limit and negative above it.
metric(Pack, thermal_margin_c, Margin) :-
  safety_limit(max_safe_temperature_c, Maximum),
  telemetry(Pack, temperature_c, Temperature),
  (Margin is Maximum - Temperature).

% Resistive heating follows P = I^2 R.
metric(Pack, resistive_heating_w, Heating) :-
  telemetry(Pack, current_a, Current),
  telemetry(Pack, internal_resistance_ohm, Resistance),
  (CurrentSquared is Current * Current),
  (Heating is CurrentSquared * Resistance).

over_temperature(Pack) :-
  telemetry(Pack, temperature_c, Temperature),
  safety_limit(max_safe_temperature_c, Maximum),
  (Temperature > Maximum).

rapid_heating(Pack) :-
  telemetry(Pack, temperature_rise_c_per_min, Rate),
  safety_limit(max_temperature_rise_c_per_min, Maximum),
  (Rate > Maximum).

cell_imbalance(Pack) :-
  telemetry(Pack, cell_delta_v, Delta),
  safety_limit(max_cell_delta_v, Maximum),
  (Delta > Maximum).

heating_exceeds_cooling(Pack) :-
  metric(Pack, resistive_heating_w, Heating),
  cooling_capacity_w(Pack, Capacity),
  (Heating > Capacity).

% Require two independent temperature channels above the same safety limit.
corroborated_over_temperature(Pack) :-
  telemetry(Pack, temperature_c, Primary),
  redundant_telemetry(Pack, temperature_c, Redundant),
  safety_limit(max_safe_temperature_c, Maximum),
  (Primary > Maximum),
  (Redundant > Maximum).

% A diagnosis needs multiple independent signatures, not one threshold alone.
diagnosis(Pack, thermal_runaway_precursor) :-
  over_temperature(Pack),
  rapid_heating(Pack),
  cell_imbalance(Pack),
  heating_exceeds_cooling(Pack).

% The safety action additionally requires redundant temperature corroboration.
action(Pack, isolate_and_cool) :-
  diagnosis(Pack, thermal_runaway_precursor),
  corroborated_over_temperature(Pack).
