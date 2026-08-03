% EYE-inspired electric-vehicle range worlds.
%
% The same trips are evaluated under four modelling worlds: base consumption,
% speed-aware consumption, physics-aware consumption, and physics plus safety
% reserve.  This makes the output a small possible-worlds comparison.
%% goal: safeInWorld(X0, X1)

%% goal: riskyInWorld(X0, X1)

%% goal: reason(X0, X1)

%% goal: status(X0, X1)


% trip_data/7 stores distance, speed, temperature, payload, battery, and base
% energy use.  The factors below adjust base consumption rather than duplicating
% one rule per trip/world pair.
trip(city_errand).
trip(winter_highway).
trip(heavy_delivery).
trip(cold_commute).

% trip_data(Trip, DistanceKm, SpeedKmh, TemperatureC, PayloadKg, BatteryKWh, BaseKWhPerKm).
trip_data(city_errand, 40, 45, 20, 100, 30, 0.18).
trip_data(winter_highway, 260, 115, -5, 400, 60, 0.20).
trip_data(heavy_delivery, 180, 80, 15, 700, 55, 0.22).
trip_data(cold_commute, 120, 90, -8, 100, 35, 0.19).

% Each world adds a different combination of speed, temperature, payload, and
% reserve factors before comparing required energy with usable battery.
speed_factor(T, 1.20) :- trip_data(T, _, S, _, _, _, _), (S > 100).
speed_factor(T, 1.00) :- trip_data(T, _, S, _, _, _, _), (S =< 100).

temperature_factor(T, 1.15) :- trip_data(T, _, _, Temp, _, _, _), (Temp < 0).
temperature_factor(T, 1.00) :- trip_data(T, _, _, Temp, _, _, _), (Temp >= 0).

payload_factor(T, 1.15) :- trip_data(T, _, _, _, P, _, _), (P > 500).
payload_factor(T, 1.08) :- trip_data(T, _, _, _, P, _, _), (P > 250), (P =< 500).
payload_factor(T, 1.00) :- trip_data(T, _, _, _, P, _, _), (P =< 250).

base_energy(T, E) :-
  trip_data(T, D, _, _, _, _, B),
  (E is D * B).

required_energy(T, w1, E) :-
  base_energy(T, E).

required_energy(T, w2, E) :-
  base_energy(T, Base),
  speed_factor(T, Sf),
  (E is Base * Sf).

required_energy(T, w0, E) :-
  base_energy(T, Base),
  speed_factor(T, Sf),
  temperature_factor(T, Tf),
  payload_factor(T, Pf),
  (A is Base * Sf),
  (B is A * Tf),
  (E is B * Pf).

required_energy(T, w3, E) :-
  required_energy(T, w0, W0),
  (E is W0 * 1.30).

% safe_in_world/2 compares required trip energy with usable battery capacity.
safe_in_world(T, W) :-
  trip_data(T, _, _, _, _, Battery, _),
  required_energy(T, W, Required),
  (Required =< Battery).

risky_in_world(T, W) :-
  trip_data(T, _, _, _, _, Battery, _),
  required_energy(T, W, Required),
  (Required > Battery).

safeInWorld(T, W) :- safe_in_world(T, W).
riskyInWorld(T, W) :- risky_in_world(T, W).
reason(winter_highway, "cold fast payload trip exceeds battery in physics-aware worlds") :-
  risky_in_world(winter_highway, w0),
  risky_in_world(winter_highway, w2),
  risky_in_world(winter_highway, w3),
  safe_in_world(winter_highway, w1).
reason(heavy_delivery, "safety buffer turns a physics-safe delivery into a cautious risk") :-
  safe_in_world(heavy_delivery, w0),
  risky_in_world(heavy_delivery, w3).
status(ev_range_worlds, expected_world_pattern) :-
  safe_in_world(city_errand, w3),
  risky_in_world(winter_highway, w0),
  risky_in_world(heavy_delivery, w3),
  safe_in_world(cold_commute, w3).
