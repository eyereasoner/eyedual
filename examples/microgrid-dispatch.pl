% Representative example: microgrid dispatch planning.
%
% The rules compute renewable supply, reserve-aware battery dispatch, remaining
% grid import, and a concise feasibility report for a campus microgrid interval.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%
% The dispatch policy is greedy but auditable: use renewables first, discharge
% the battery only down to reserve, then import the remaining deficit from grid.
%% goal: renewablePower_kW(X0, X1)

%% goal: batteryDispatch_kW(X0, X1)

%% goal: gridImport_kW(X0, X1)

%% goal: reserveAfterDispatch_kW(X0, X1)

%% goal: status(X0, X1)

%% goal: reason(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
site(campus_interval_17).

load_kW(campus_interval_17, 620.0).
solar_kW(campus_interval_17, 180.0).
wind_kW(campus_interval_17, 90.0).
battery_max_discharge_kW(campus_interval_17, 320.0).
required_battery_reserve_kW(campus_interval_17, 80.0).
grid_contract_limit_kW(campus_interval_17, 150.0).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
renewable_kW(Site, Renewable) :-
  solar_kW(Site, Solar),
  wind_kW(Site, Wind),
  (Renewable is Solar + Wind).

net_deficit_kW(Site, Deficit) :-
  load_kW(Site, Load),
  renewable_kW(Site, Renewable),
  (Deficit is Load - Renewable).

reserve_aware_battery_limit_kW(Site, Limit) :-
  battery_max_discharge_kW(Site, Maxdischarge),
  required_battery_reserve_kW(Site, Reserve),
  (Limit is Maxdischarge - Reserve).

battery_dispatch_kW(Site, Dispatch) :-
  net_deficit_kW(Site, Deficit),
  reserve_aware_battery_limit_kW(Site, Limit),
  (Deficit =< Limit -> Dispatch = Deficit ; Dispatch = Limit).

grid_import_kW(Site, Import) :-
  net_deficit_kW(Site, Deficit),
  battery_dispatch_kW(Site, Dispatch),
  (Import is Deficit - Dispatch).

battery_reserve_after_dispatch_kW(Site, Reserveleft) :-
  battery_max_discharge_kW(Site, Maxdischarge),
  battery_dispatch_kW(Site, Dispatch),
  (Reserveleft is Maxdischarge - Dispatch).

contract_ok(Site) :-
  grid_import_kW(Site, Import),
  grid_contract_limit_kW(Site, Limit),
  (Import =< Limit).

reserve_ok(Site) :-
  battery_reserve_after_dispatch_kW(Site, Reserveleft),
  required_battery_reserve_kW(Site, Required),
  (Reserveleft >= Required).

% stable_dispatch/1 passes only when contract and reserve constraints remain satisfied.
stable_dispatch(Site) :-
  contract_ok(Site),
  reserve_ok(Site).

renewablePower_kW(Site, Renewable) :-
  renewable_kW(Site, Renewable).

batteryDispatch_kW(Site, Dispatch) :-
  battery_dispatch_kW(Site, Dispatch).

gridImport_kW(Site, Import) :-
  grid_import_kW(Site, Import).

reserveAfterDispatch_kW(Site, Reserveleft) :-
  battery_reserve_after_dispatch_kW(Site, Reserveleft).

status(Site, stable_dispatch) :-
  stable_dispatch(Site).

reason(Site, "battery dispatch covers the deficit while preserving reserve and grid contract limits") :-
  stable_dispatch(Site).
