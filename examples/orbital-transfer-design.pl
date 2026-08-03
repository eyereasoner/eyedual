% Ambitious STEM example: Hohmann transfer design from Earth orbit to Mars orbit.
%
% The rules combine orbital mechanics, numerical math, and engineering-style
% mission constraints. Distances are in kilometres, speeds in kilometres per
% second, and time in days.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%
% The design is a Hohmann-transfer estimate: compute transfer orbit geometry,
% departure/arrival burns, total delta-v, transfer time, and budget status.
%% goal: transferSemiMajorAxis_km(X0, X1)

%% goal: departureDeltaV_km_s(X0, X1)

%% goal: arrivalDeltaV_km_s(X0, X1)

%% goal: totalDeltaV_km_s(X0, X1)

%% goal: transferTime_days(X0, X1)

%% goal: status(X0, X1)

%% goal: reason(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
mission(mars_hohmann, centralBodyMu_km3_s2, 132712440018.0).
mission(mars_hohmann, departureOrbitRadius_km, 149597870.7).
mission(mars_hohmann, arrivalOrbitRadius_km, 227939200.0).
mission(mars_hohmann, deltaVBudget_km_s, 6.0).
mission(mars_hohmann, pi, 3.141592653589793).
mission(mars_hohmann, secondsPerDay, 86400.0).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
semi_major_axis(Mission, Axis) :-
  mission(Mission, departureOrbitRadius_km, R1),
  mission(Mission, arrivalOrbitRadius_km, R2),
  (Sum is R1 + R2),
  (Axis is Sum / 2.0).

circular_speed_at_departure(Mission, Speed) :-
  mission(Mission, centralBodyMu_km3_s2, Mu),
  mission(Mission, departureOrbitRadius_km, Radius),
  (Speedsquared is Mu / Radius),
  (Speed is Speedsquared ** 0.5).

circular_speed_at_arrival(Mission, Speed) :-
  mission(Mission, centralBodyMu_km3_s2, Mu),
  mission(Mission, arrivalOrbitRadius_km, Radius),
  (Speedsquared is Mu / Radius),
  (Speed is Speedsquared ** 0.5).

transfer_speed_at_departure(Mission, Speed) :-
  mission(Mission, centralBodyMu_km3_s2, Mu),
  mission(Mission, departureOrbitRadius_km, Radius),
  semi_major_axis(Mission, Axis),
  (Twiceoverradius is 2.0 / Radius),
  (Oneoveraxis is 1.0 / Axis),
  (Bracket is Twiceoverradius - Oneoveraxis),
  (Speedsquared is Mu * Bracket),
  (Speed is Speedsquared ** 0.5).

transfer_speed_at_arrival(Mission, Speed) :-
  mission(Mission, centralBodyMu_km3_s2, Mu),
  mission(Mission, arrivalOrbitRadius_km, Radius),
  semi_major_axis(Mission, Axis),
  (Twiceoverradius is 2.0 / Radius),
  (Oneoveraxis is 1.0 / Axis),
  (Bracket is Twiceoverradius - Oneoveraxis),
  (Speedsquared is Mu * Bracket),
  (Speed is Speedsquared ** 0.5).

departure_delta_v(Mission, Deltav) :-
  transfer_speed_at_departure(Mission, Transferspeed),
  circular_speed_at_departure(Mission, Circularspeed),
  (Deltav is Transferspeed - Circularspeed).

arrival_delta_v(Mission, Deltav) :-
  circular_speed_at_arrival(Mission, Circularspeed),
  transfer_speed_at_arrival(Mission, Transferspeed),
  (Deltav is Circularspeed - Transferspeed).

total_delta_v(Mission, Total) :-
  departure_delta_v(Mission, Depart),
  arrival_delta_v(Mission, Arrive),
  (Total is Depart + Arrive).

transfer_time_days(Mission, Days) :-
  semi_major_axis(Mission, Axis),
  mission(Mission, centralBodyMu_km3_s2, Mu),
  mission(Mission, pi, Pi),
  mission(Mission, secondsPerDay, Secondsperday),
  (Axiscubed is Axis ** 3.0),
  (Timefactor is Axiscubed / Mu),
  (Halfperiodbase is Timefactor ** 0.5),
  (Seconds is Pi * Halfperiodbase),
  (Days is Seconds / Secondsperday).

within_delta_v_budget(Mission) :-
  total_delta_v(Mission, Total),
  mission(Mission, deltaVBudget_km_s, Budget),
  (Total =< Budget).

transferSemiMajorAxis_km(Mission, Axis) :-
  semi_major_axis(Mission, Axis).

departureDeltaV_km_s(Mission, Deltav) :-
  departure_delta_v(Mission, Deltav).

arrivalDeltaV_km_s(Mission, Deltav) :-
  arrival_delta_v(Mission, Deltav).

totalDeltaV_km_s(Mission, Total) :-
  total_delta_v(Mission, Total).

transferTime_days(Mission, Days) :-
  transfer_time_days(Mission, Days).

status(Mission, feasible_reference_transfer) :-
  within_delta_v_budget(Mission).

reason(Mission, "total Hohmann transfer delta-v is within the mission budget") :-
  within_delta_v_budget(Mission).
